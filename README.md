# AI Coding Statuslines

Shared status lines for Codex, Google Antigravity CLI (`agy`), and Claude Code.

See your model, reasoning mode, working directory, Git branch, changed files, context usage, context-window size, and five-hour/weekly usage limits while you work.

## What this solves

AI coding agents hide important session information in menus or slash commands. These status lines keep the most useful signals visible in the terminal:

```text
Claude Opus (high) | 📁 my-project | git:main Δ3 | ctx 24% (24k/200k) | win 200k | 5h 82% left | 7d 61% left
```

The three agents expose different payloads, so each implementation uses that agent's supported configuration format while keeping the displayed information consistent.

## Install

Clone this repository, then follow the agent-specific guide:

```bash
git clone https://github.com/naman-in-ml/ai-coding-statuslines.git
cd ai-coding-statuslines
```

- [Codex](codex/README.md)
- [Antigravity CLI](antigravity/README.md)
- [Claude Code](claude-code/README.md)

## Compatibility

| Agent | Configuration | Core fields |
|---|---|---|
| Codex | `~/.codex/config.toml` | Native status-line items |
| Antigravity CLI | `~/.gemini/antigravity-cli/settings.json` + command | JSON payload command |
| Claude Code | `~/.claude/settings.json` + command | JSON payload command |

## Search terms

This project is for developers searching for: Codex status line, Claude Code statusline, Antigravity CLI status line, agy statusline, AI coding agent quota display, context window indicator, Git branch terminal status, coding assistant usage limits, and terminal AI usage tracker.

## Safety

The scripts only read agent-provided session data and local Git metadata. They do not send telemetry or store credentials. Review the files before installing them on a shared machine.

## License

MIT
