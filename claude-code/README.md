# Claude Code

This status line shows the model and reasoning level, current folder, Git branch and changed files, context usage, context-window size, five-hour and weekly limits, and session cost.

## Requirements

- macOS or Linux (Windows uses the PowerShell script below).
- `jq`. The script reads Claude Code's JSON payload with it. Without `jq` the status line is blank and prints no error.
- `git` (optional). Without it, the branch and changed-file fields are omitted.
- Claude Code installed and signed in.

Check for `jq` and `git`:

```bash
jq --version
git --version
```

Install `jq` if needed:

| System | Command |
| --- | --- |
| Ubuntu / Debian | `sudo apt install jq` |
| Fedora | `sudo dnf install jq` |
| Arch | `sudo pacman -S jq` |
| macOS (Homebrew) | `brew install jq` |

## macOS and Linux install

Run these commands from the `ai-coding-statuslines` directory after cloning the repository.

### Step 1 — back up your current settings

```bash
mkdir -p "$HOME/.claude"
cp "$HOME/.claude/settings.json" "$HOME/.claude/settings.json.backup" 2>/dev/null || true
```

The `|| true` means the command still succeeds if you have no settings file yet.

### Step 2 — copy the script to a permanent location

Do not run the script from the repository. If you later move or delete the repository, the status line breaks. Copy it to `~/.local/bin`, which is normally on your `PATH` and survives repository changes.

```bash
mkdir -p "$HOME/.local/bin"
install -m 755 claude-code/statusline.sh "$HOME/.local/bin/claude-statusline.sh"
```

`install -m 755` copies the file and marks it executable in one step.

Check that it worked:

```bash
ls -l "$HOME/.local/bin/claude-statusline.sh"
```

You should see an `x` in the permission string, for example `-rwxr-xr-x`.

### Step 3 — add the status line to Claude Code

Open the settings file:

```bash
nano "$HOME/.claude/settings.json"
```

Add this inside the outer `{ ... }`, beside any keys that are already there:

```json
"statusLine": {
  "type": "command",
  "command": "/home/YOUR_NAME/.local/bin/claude-statusline.sh",
  "padding": 1,
  "refreshInterval": 30
}
```

Replace `/home/YOUR_NAME` with your real home directory:

```bash
echo "$HOME"
```

For example, if `echo "$HOME"` prints `/home/alex`, the command becomes:

```json
"command": "/home/alex/.local/bin/claude-statusline.sh"
```

If the file was empty, the complete contents should be:

```json
{
  "statusLine": {
    "type": "command",
    "command": "/home/YOUR_NAME/.local/bin/claude-statusline.sh",
    "padding": 1,
    "refreshInterval": 30
  }
}
```

If the file already had settings, the result looks like this:

```json
{
  "theme": "dark",
  "statusLine": {
    "type": "command",
    "command": "/home/YOUR_NAME/.local/bin/claude-statusline.sh",
    "padding": 1,
    "refreshInterval": 30
  }
}
```

Save and exit nano with `Ctrl+O`, `Enter`, then `Ctrl+X`.

> **Common mistakes**
>
> - Claude Code does not expand `~`. A command like `"command": "~/bin/statusline.sh"` will not run. Use the full path.
> - JSON does not allow a comma after the last key in an object. If `statusLine` is followed by another key, put a comma after its closing `}`, not before it.
> - Do not delete existing settings such as `"theme": "dark"`. Add `statusLine` next to them.
> - Do not add a second `statusLine` key. If one already exists, replace it.

Check that the file is valid JSON:

```bash
python3 -m json.tool "$HOME/.claude/settings.json" > /dev/null && echo "valid JSON"
```

### Step 4 — test the script before restarting

This feeds the script a sample payload:

```bash
printf '%s' '{"model":{"display_name":"Claude Sonnet 4.5","reasoning_effort":"high"},"workspace":{"current_dir":"'"$PWD"'"},"cost":{"total_cost_usd":0.1284},"context_window":{"used_percentage":23.7,"context_window_size":200000},"rate_limits":{"five_hour":{"used_percentage":12},"seven_day":{"used_percentage":40}}}' | "$HOME/.local/bin/claude-statusline.sh"
```

Expected output, with values that depend on your folder and Git state:

```text
Claude Sonnet 4.5 (high) 📁 ai-coding-statuslines git:main ctx 23% win 200000 5h 12% used 7d 40% used $0.13
```

If this prints nothing, see [Troubleshooting](#troubleshooting).

### Step 5 — restart Claude Code

Quit `claude` completely and start it again. Settings are read at startup. The status line then appears at the bottom of the window and refreshes while you work.

## Windows

Use `statusline.ps1` and configure the command with PowerShell in `%USERPROFILE%\.claude\settings.json`:

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

Copy `statusline.ps1` to `C:\Users\YOUR_NAME\statusline.ps1` first, replacing `YOUR_NAME`. Install Git for Windows so the branch and changed-file fields can be read, then restart Claude Code.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| Nothing appears | Restart Claude Code fully. |
| Status line is blank | `jq` is missing. Run `jq --version` and install it if needed. |
| `Permission denied` | Run `chmod +x "$HOME/.local/bin/claude-statusline.sh"`. |
| `No such file or directory` | The path in `settings.json` is wrong. Run `ls -l "$HOME/.local/bin/claude-statusline.sh"`. |
| Status line still blank | Confirm the command uses a full path, not `~`. |
| `Invalid JSON` in Claude Code | Run `python3 -m json.tool "$HOME/.claude/settings.json"` to find the error. |
| No branch shown | The current folder is not a Git repository; that field is omitted. |
| No cost shown | Claude Code only sends a cost value when one is available. A zero cost is hidden. |

## Uninstall

1. Restore your backup, or remove the `statusLine` block from `~/.claude/settings.json`:

   ```bash
   cp "$HOME/.claude/settings.json.backup" "$HOME/.claude/settings.json"
   ```

2. Delete the script:

   ```bash
   rm -f "$HOME/.local/bin/claude-statusline.sh"
   ```

3. Restart Claude Code.
