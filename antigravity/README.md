# Google Antigravity CLI (`agy`)

Copy `agy-statusline.py` to a stable executable location, make it executable, and point `statusLine.command` at it in `~/.gemini/antigravity-cli/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "/absolute/path/to/agy-statusline.py",
    "enabled": true,
    "stack_with_default": false
  }
}
```

The command reads Antigravity's JSON payload from stdin and prints model/reasoning, directory, Git branch/changes, context, window size, and Gemini five-hour/weekly quota remaining.
