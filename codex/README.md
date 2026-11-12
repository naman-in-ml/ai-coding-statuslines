# Codex

Add this to `~/.codex/config.toml`:

```toml
[tui]
status_line = ["model-with-reasoning", "current-dir", "git-branch", "branch-changes", "context-used", "context-window-size", "five-hour-limit", "weekly-limit"]
```

Restart Codex after editing the file. Run `/status` for the detailed session view.
