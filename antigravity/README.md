# Google Antigravity CLI (`agy`)

This status line shows the model and reasoning level, current folder, Git branch and changed files, context usage, context-window size, and Gemini five-hour and weekly quota remaining.

## Requirements

- macOS or Linux.
- `python3`. The script is written in Python.
- `git` (optional). Without it, the branch and changed-file fields are omitted.
- Google Antigravity CLI installed and signed in.

Check for `python3` and `git`:

```bash
python3 --version
git --version
```

Install `python3` if needed:

| System | Command |
| --- | --- |
| Ubuntu / Debian | `sudo apt install python3` |
| Fedora | `sudo dnf install python3` |
| Arch | `sudo pacman -S python3` |
| macOS (Homebrew) | `brew install python3` |

## Install

Run these commands from the `ai-coding-statuslines` directory after cloning the repository.

### Step 1 — back up your current settings

```bash
mkdir -p "$HOME/.gemini/antigravity-cli"
cp "$HOME/.gemini/antigravity-cli/settings.json" "$HOME/.gemini/antigravity-cli/settings.json.backup" 2>/dev/null || true
```

The `|| true` means the command still succeeds if you have no settings file yet.

### Step 2 — copy the script to a permanent location

Do not run the script from the repository. If you later move or delete the repository, the status line breaks. Copy it to `~/.local/bin`.

```bash
mkdir -p "$HOME/.local/bin"
install -m 755 antigravity/agy-statusline.py "$HOME/.local/bin/agy-statusline.py"
```

`install -m 755` copies the file and marks it executable in one step.

Check that it worked:

```bash
ls -l "$HOME/.local/bin/agy-statusline.py"
```

You should see an `x` in the permission string, for example `-rwxr-xr-x`.

### Step 3 — point Antigravity at the script

Open the settings file:

```bash
nano "$HOME/.gemini/antigravity-cli/settings.json"
```

Replace the existing `statusLine` block with this one:

```json
"statusLine": {
  "type": "command",
  "command": "/home/YOUR_NAME/.local/bin/agy-statusline.py",
  "enabled": true,
  "stack_with_default": false
}
```

Replace `/home/YOUR_NAME` with your real home directory:

```bash
echo "$HOME"
```

For example, if `echo "$HOME"` prints `/home/alex`, the command becomes:

```json
"command": "/home/alex/.local/bin/agy-statusline.py"
```

The block must sit inside the outer `{ ... }` of the file. If you had no `statusLine` block, add it beside your existing settings. Do not delete keys such as `agentMode` or `permissions`.

> **Common mistake:** Antigravity often ships with a placeholder block:
>
> ```json
> "statusLine": {
>   "type": "",
>   "command": "",
>   "enabled": false
> }
> ```
>
> Replace that block. Do not add a second `statusLine` key, and do not leave `enabled` set to `false`.

Save and exit nano with `Ctrl+O`, `Enter`, then `Ctrl+X`.

Check that the file is valid JSON:

```bash
python3 -m json.tool "$HOME/.gemini/antigravity-cli/settings.json" > /dev/null && echo "valid JSON"
```

### Step 4 — test the script before restarting

This feeds the script a sample payload:

```bash
printf '%s' '{"model":{"display_name":"Gemini 3.8 Flash","effort":"high"},"workspace":{"current_dir":"'"$PWD"'"},"context_window":{"used_percentage":31,"context_window_size":1000000},"quota":{"gemini-5h":{"remaining_fraction":0.88},"gemini-weekly":{"remaining_fraction":0.6}}}' | python3 "$HOME/.local/bin/agy-statusline.py"
```

Expected output, with values that depend on your folder and Git state:

```text
Gemini 3.8 Flash (high) | 📁 ai-coding-statuslines | git:main | ctx 31% | win 1,000,000 | 5h 88% left | 7d 60% left
```

If this prints an error, see [Troubleshooting](#troubleshooting).

### Step 5 — restart Antigravity

Quit `agy` completely and start it again. Settings are read at startup.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| Nothing appears | Restart `agy` fully and confirm `"enabled": true`. |
| `Permission denied` | Run `chmod +x "$HOME/.local/bin/agy-statusline.py"`. |
| `No such file or directory` | The path in `settings.json` is wrong. Run `ls -l "$HOME/.local/bin/agy-statusline.py"`. |
| `python3: command not found` | Install `python3` using the table above. |
| `Invalid JSON` in Antigravity | Run `python3 -m json.tool "$HOME/.gemini/antigravity-cli/settings.json"` to find the error. |
| Only model and folder appear | Antigravity has not sent context or quota values yet. Those fields appear once the agent reports them. |
| No branch shown | The current folder is not a Git repository; that field is omitted. |
| Default status bar still appears | Set `"stack_with_default": false` to replace it. |

## Uninstall

1. Restore your backup, or set `"enabled": false` in the `statusLine` block:

   ```bash
   cp "$HOME/.gemini/antigravity-cli/settings.json.backup" "$HOME/.gemini/antigravity-cli/settings.json"
   ```

2. Delete the script:

   ```bash
   rm -f "$HOME/.local/bin/agy-statusline.py"
   ```

3. Restart Antigravity.
