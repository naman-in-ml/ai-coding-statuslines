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

## Windows

Use `statusline.ps1` and configure the command with PowerShell in `%USERPROFILE%\\.claude\\settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\\Users\\YOUR_NAME\\statusline.ps1",
    "padding": 1,
    "refreshInterval": 30
  }
}
```

Install Git for Windows so the branch and changed-file fields can be read.
