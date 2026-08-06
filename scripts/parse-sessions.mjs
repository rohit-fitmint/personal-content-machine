#!/usr/bin/env node
// parse-sessions.mjs — mine Claude Code + Claude chat sessions for content raw material.
//
// Reads every ~/.claude/projects/<project>/*.jsonl transcript, keeps the last N days,
// strips tool noise, and emits a clean human-readable digest of YOUR prompts and
// Claude's text replies — grouped by project and session. This is mechanical
// extraction only: the /oracle command reads this digest and does the actual
// idea-scoring. Don't try to be clever here; just produce faithful, de-noised text.
//
// Usage:
//   node scripts/parse-sessions.mjs                 # last 7 days, all projects
//   node scripts/parse-sessions.mjs --days 3        # last 3 days
//   node scripts/parse-sessions.mjs --project user-research   # substring filter
//   node scripts/parse-sessions.mjs --max-chars 1200          # cap per message
//
// Output: markdown to stdout.

import { readdir, readFile, stat } from "node:fs/promises";
import { existsSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

// ---- args ----
const args = process.argv.slice(2);
const getArg = (name, fallback) => {
  const i = args.indexOf(`--${name}`);
  return i !== -1 && args[i + 1] ? args[i + 1] : fallback;
};
const DAYS = parseInt(getArg("days", "7"), 10);
const PROJECT_FILTER = getArg("project", "");
const MAX_CHARS = parseInt(getArg("max-chars", "1500"), 10);

const PROJECTS_DIR = join(homedir(), ".claude", "projects");
const cutoff = Date.now() - DAYS * 24 * 60 * 60 * 1000;

// ---- helpers ----
// Pull plain text out of a message.content that may be a string or an array of blocks.
function extractText(content) {
  if (typeof content === "string") return content;
  if (!Array.isArray(content)) return "";
  return content
    .filter((b) => b && b.type === "text" && typeof b.text === "string")
    .map((b) => b.text)
    .join("\n")
    .trim();
}

// Is this a tool-result carrier masquerading as a user turn?
function isToolResult(content) {
  return (
    Array.isArray(content) &&
    content.some((b) => b && (b.type === "tool_result" || b.type === "tool_use"))
  );
}

// Drop harness-injected noise so the digest reads like a real conversation.
const NOISE_MARKERS = [
  "<system-reminder>",
  "<command-name>",
  "<command-message>",
  "<local-command-stdout>",
  "Caveat: The messages below",
  "[Request interrupted",
  "This session is being continued from a previous",
];
function looksLikeNoise(text) {
  if (!text) return true;
  const t = text.trim();
  if (!t) return true;
  return NOISE_MARKERS.some((m) => t.includes(m));
}

function clamp(text) {
  const t = text.trim().replace(/\n{3,}/g, "\n\n");
  return t.length > MAX_CHARS ? t.slice(0, MAX_CHARS) + " […]" : t;
}

function projectLabel(dirName, cwd) {
  if (cwd) return cwd.split("/").filter(Boolean).pop();
  // Claude stores transcripts under ~/.claude/projects/ with the project path
  // munged into the dir name, e.g. "-Users-<you>-Projects-my-app". Strip the
  // leading "-Users-<user>-...-" prefix for a readable label; fall back to the raw name.
  return dirName.replace(/^-Users-[^-]+-([A-Za-z]+-)?/, "").replace(/^-+/, "") || dirName;
}

// ---- parse one transcript file ----
async function parseFile(filePath, dirName) {
  let raw;
  try {
    raw = await readFile(filePath, "utf8");
  } catch {
    return null;
  }
  const turns = [];
  let projName = null;
  let firstTs = null;
  let lastTs = null;

  for (const line of raw.split("\n")) {
    if (!line.trim()) continue;
    let obj;
    try {
      obj = JSON.parse(line);
    } catch {
      continue;
    }
    if (obj.isSidechain) continue; // subagent chatter — skip
    const ts = obj.timestamp ? Date.parse(obj.timestamp) : NaN;
    if (Number.isNaN(ts) || ts < cutoff) continue;
    if (!projName && obj.cwd) projName = projectLabel(dirName, obj.cwd);

    const msg = obj.message;
    if (!msg) continue;

    if (obj.type === "user" && msg.role === "user") {
      // Only genuine human prompts — not tool results fed back to the model.
      const human = obj.origin && obj.origin.kind === "human";
      if (!human) continue;
      if (isToolResult(msg.content)) continue;
      const text = extractText(msg.content);
      if (looksLikeNoise(text)) continue;
      turns.push({ ts, who: "You", text: clamp(text) });
    } else if (obj.type === "assistant" && msg.role === "assistant") {
      const text = extractText(msg.content);
      if (looksLikeNoise(text) || !text) continue; // pure thinking/tool_use turns
      turns.push({ ts, who: "Claude", text: clamp(text) });
    }
    if (turns.length) {
      if (firstTs === null) firstTs = ts;
      lastTs = ts;
    }
  }

  if (!turns.length) return null;
  return {
    project: projName || projectLabel(dirName, null),
    firstTs,
    lastTs,
    turns,
  };
}

// ---- main ----
async function main() {
  if (!existsSync(PROJECTS_DIR)) {
    console.error(`No projects dir at ${PROJECTS_DIR}`);
    process.exit(1);
  }
  const dirEntries = await readdir(PROJECTS_DIR, { withFileTypes: true });
  const sessions = [];

  for (const entry of dirEntries) {
    if (!entry.isDirectory()) continue;
    if (PROJECT_FILTER && !entry.name.includes(PROJECT_FILTER)) continue;
    const dirPath = join(PROJECTS_DIR, entry.name);
    let files;
    try {
      files = await readdir(dirPath);
    } catch {
      continue;
    }
    for (const f of files) {
      if (!f.endsWith(".jsonl")) continue;
      const filePath = join(dirPath, f);
      // Cheap mtime pre-filter: skip files untouched within the window.
      try {
        const s = await stat(filePath);
        if (s.mtimeMs < cutoff) continue;
      } catch {
        continue;
      }
      const parsed = await parseFile(filePath, entry.name);
      if (parsed) sessions.push({ ...parsed, file: f });
    }
  }

  // newest sessions first
  sessions.sort((a, b) => b.lastTs - a.lastTs);

  const fmtDate = (ts) => new Date(ts).toISOString().slice(0, 16).replace("T", " ");
  const out = [];
  out.push(`# Claude session digest — last ${DAYS} days`);
  out.push(
    `Generated over ${sessions.length} active session(s)${PROJECT_FILTER ? ` (project filter: "${PROJECT_FILTER}")` : ""}.`
  );
  out.push(
    `Each block is a real conversation between you and Claude. Mine these for: struggles, breakthroughs, strong opinions, decisions, funny moments, and repeated themes.\n`
  );

  if (!sessions.length) {
    out.push("_No human/assistant turns found in the window._");
  }

  for (const s of sessions) {
    out.push(`\n---\n## Project: ${s.project}  ·  ${fmtDate(s.firstTs)} → ${fmtDate(s.lastTs)} UTC`);
    out.push(`_session file: ${s.file}_\n`);
    for (const t of s.turns) {
      out.push(`**${t.who}:** ${t.text}\n`);
    }
  }

  process.stdout.write(out.join("\n") + "\n");
}

main().catch((e) => {
  console.error("parse-sessions failed:", e);
  process.exit(1);
});
