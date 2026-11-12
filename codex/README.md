# Codex

Codex has a built-in status line, so there is no script to copy. You only edit one configuration file.

## Requirements

- Codex CLI installed and signed in.
- `git` (optional). Without it, the branch and changed-file fields are omitted.

## Install

Run these commands from the `ai-coding-statuslines` directory after cloning the repository.

### Step 1 — back up your current config

```bash
mkdir -p "$HOME/.codex"
cp "$HOME/.codex/config.toml" "$HOME/.codex/config.toml.backup" 2>/dev/null || true
```

The `|| true` means the command still succeeds if you have no config file yet.

### Step 2 — open the config file

```bash
nano "$HOME/.codex/config.toml"
```

### Step 3 — add the status line under `[tui]`

Find the `[tui]` section and add the `status_line` line directly under it:

```toml
[tui]
status_line = ["model-with-reasoning", "current-dir", "git-branch", "branch-changes", "context-used", "context-window-size", "five-hour-limit", "weekly-limit"]
```

If the file already has a `[tui]` section, do not create a second one. Add only the `status_line` line under the existing header:

```toml
[tui]
status_line = ["model-with-reasoning", "current-dir", "git-branch", "branch-changes", "context-used", "context-window-size", "five-hour-limit", "weekly-limit"]
screen_reader_detection_done = true
```

If there is no `[tui]` section at all, add both lines at the end of the file.

Save and exit nano with `Ctrl+O`, `Enter`, then `Ctrl+X`.

> **Common mistake:** in TOML, a key belongs to the nearest section header above it. If you paste `status_line` at the bottom of the file, it belongs to whatever section comes last (often `[apps...]` or `[projects...]`) and Codex ignores it. It must sit directly under `[tui]`.

### Step 4 — confirm the line is in the right place

```bash
grep -n -A2 '^\[tui\]' "$HOME/.codex/config.toml"
```

`status_line` should appear immediately after `[tui]`, before any other section header.

### Step 5 — restart Codex

Quit the `codex` session completely and start it again. The config is read at startup.

The fields you listed should now appear at the bottom of the window. Run `/status` for the detailed session view.

## Available fields

You can remove fields you do not want, or reorder them, by editing the list. Keep the TOML array commas intact.

| Field | Shows |
| --- | --- |
| `model-with-reasoning` | Model name and reasoning effort |
| `current-dir` | Current working directory |
| `git-branch` | Current Git branch |
| `branch-changes` | Number of changed files |
| `context-used` | Context used in the session |
| `context-window-size` | Total context-window size |
| `five-hour-limit` | Five-hour usage limit |
| `weekly-limit` | Weekly usage limit |

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| Nothing appears | Restart Codex fully and confirm the line is directly under `[tui]`. |
| Config error on startup | A TOML syntax error, often a missing comma or quote in the array. Compare with the snippet above. |
| Only some fields appear | Codex omits a field when the value is not available yet, for example before the first message. |
| No branch shown | The current folder is not a Git repository; that field is omitted. |
| Settings seem ignored | Check for a second `[tui]` section or a duplicate `status_line` key. Only one of each may exist. |

## Uninstall

1. Restore your backup, or delete the `status_line` line from `~/.codex/config.toml`:

   ```bash
   cp "$HOME/.codex/config.toml.backup" "$HOME/.codex/config.toml"
   ```

2. Restart Codex.
