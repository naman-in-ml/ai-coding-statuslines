# Claude Code

Copy `statusline.sh` to a stable executable location, make it executable, then add this to `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "/absolute/path/to/statusline.sh",
    "padding": 1,
    "refreshInterval": 30
  }
}
```

Claude Code also shows cost and reset countdowns when those values are present in its payload.
