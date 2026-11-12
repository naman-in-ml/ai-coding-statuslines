# AI Coding Statuslines

Status lines for Codex, Google Antigravity CLI (`agy`), and Claude Code.

They show useful information directly in your terminal:

- Model and reasoning mode
- Current working directory
- Git branch and changed files
- Context usage and context-window size
- Five-hour and weekly usage limits

## Problem this solves

AI coding agents often hide context usage, Git state, and account limits behind menus or commands. These status lines keep that information visible while you work, so you can see when a session is getting full or a usage limit is approaching.

---

## Before you start

You need:

- macOS or Linux. For Windows, see [Claude Code](claude-code/README.md#windows).
- A terminal.
- `git`.
- One or more of: Codex CLI, Claude Code, or Google Antigravity CLI.
- `jq` **only if you use Claude Code**.
- `python3` **only if you use Antigravity**.

Check what you have:

```bash
git --version
jq --version        # only needed for Claude Code
python3 --version   # only needed for Antigravity
```

If something is missing:

| System | Install command |
| --- | --- |
| Ubuntu / Debian | `sudo apt install jq python3` |
| Fedora | `sudo dnf install jq python3` |
| Arch | `sudo pacman -S jq python3` |
| macOS (Homebrew) | `brew install jq python3` |

The status line does **not** work without these tools. If `jq` is missing, the Claude Code status line prints nothing and shows no error.

---

## Install

These steps copy the scripts out of the repository and into `~/.local/bin`, which is a stable per-user location that is already on your `PATH` on most systems. Copying is important: if you later move or delete the repository, your status line keeps working.

### Step 1 — get the files

```bash
git clone https://github.com/naman-in-ml/ai-coding-statuslines.git
cd ai-coding-statuslines
```

### Step 2 — open a terminal in the repository

Run every command below from the `ai-coding-statuslines` directory. If you closed the terminal, reopen it and run:

```bash
cd ai-coding-statuslines
```

### Step 3 — install the status line for your agent

Pick the agent(s) you use. You can install one, two, or all three.

- [Codex](#codex)
- [Google Antigravity CLI](#google-antigravity-cli)
- [Claude Code](#claude-code)

#### Codex

Codex has a built-in status line, so there is no script to copy. You only edit one config file.

1. Open the config file:

   ```bash
   mkdir -p "$HOME/.codex"
   nano "$HOME/.codex/config.toml"
   ```

2. Find the `[tui]` section. Add this line **directly under `[tui]`**:

   ```toml
   [tui]
   status_line = ["model-with-reasoning", "current-dir", "git-branch", "branch-changes", "context-used", "context-window-size", "five-hour-limit", "weekly-limit"]
   ```

3. If there is no `[tui]` section, add the two lines above to the end of the file.

4. Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X` in nano).

> **Common mistake:** a TOML key belongs to the section header above it. If you paste `status_line` at the bottom of the file, it belongs to whatever section is above it (often `[apps...]`) and Codex ignores it. It must sit directly under `[tui]`.

#### Google Antigravity CLI

1. Copy the script somewhere permanent and make it executable:

   ```bash
   mkdir -p "$HOME/.local/bin"
   install -m 755 antigravity/agy-statusline.py "$HOME/.local/bin/agy-statusline.py"
   ```

2. Open the Antigravity settings file:

   ```bash
   nano "$HOME/.gemini/antigravity-cli/settings.json"
   ```

3. Replace the existing `statusLine` block with this one. If there is no `statusLine` block, add it inside the outer `{ ... }`:

   ```json
   "statusLine": {
     "type": "command",
     "command": "/home/YOUR_NAME/.local/bin/agy-statusline.py",
     "enabled": true,
     "stack_with_default": false
   }
   ```

4. Replace `/home/YOUR_NAME` with your real home directory. To print it:

   ```bash
   echo "$HOME"
   ```

5. Save and exit.

> **Common mistake:** the settings file often already contains `"statusLine": { "type": "", "command": "", "enabled": false }`. Replace that block; do not add a second `statusLine` key.

#### Claude Code

1. Copy the script somewhere permanent and make it executable:

   ```bash
   mkdir -p "$HOME/.local/bin"
   install -m 755 claude-code/statusline.sh "$HOME/.local/bin/claude-statusline.sh"
   ```

2. Open the Claude Code settings file:

   ```bash
   mkdir -p "$HOME/.claude"
   nano "$HOME/.claude/settings.json"
   ```

3. Add this key inside the outer `{ ... }`, next to any existing keys:

   ```json
   "statusLine": {
     "type": "command",
     "command": "/home/YOUR_NAME/.local/bin/claude-statusline.sh",
     "padding": 1,
     "refreshInterval": 30
   }
   ```

4. Replace `/home/YOUR_NAME` with your real home directory. To print it:

   ```bash
   echo "$HOME"
   ```

5. If the file was empty, the whole file should look like this:

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

6. Save and exit.

> **Common mistakes:**
> - Claude Code does not expand `~`. Use a full path such as `/home/alex/.local/bin/claude-statusline.sh`.
> - JSON does not allow a comma after the last key in an object. If you add `statusLine` before another key, it needs a comma after its closing `}`.
> - Do not delete existing settings such as `"theme": "dark"`. Add `statusLine` beside them.

### Step 4 — verify the install

Run this before restarting the agent. It feeds the script a sample payload and should print a status line.

**Claude Code:**

```bash
printf '%s' '{"model":{"display_name":"Claude Sonnet 4.5","reasoning_effort":"high"},"workspace":{"current_dir":"'"$PWD"'"},"cost":{"total_cost_usd":0.1284},"context_window":{"used_percentage":23.7,"context_window_size":200000},"rate_limits":{"five_hour":{"used_percentage":12},"seven_day":{"used_percentage":40}}}' | "$HOME/.local/bin/claude-statusline.sh"
```

Expected output (values depend on your folder and Git state):

```text
Claude Sonnet 4.5 (high) 📁 ai-coding-statuslines git:main ctx 23% win 200000 5h 12% used 7d 40% used $0.13
```

**Antigravity:**

```bash
printf '%s' '{"model":{"display_name":"Gemini 3.8 Flash","effort":"high"},"workspace":{"current_dir":"'"$PWD"'"},"context_window":{"used_percentage":31,"context_window_size":1000000},"quota":{"gemini-5h":{"remaining_fraction":0.88},"gemini-weekly":{"remaining_fraction":0.6}}}' | python3 "$HOME/.local/bin/agy-statusline.py"
```

Expected output:

```text
Gemini 3.8 Flash (high) | 📁 ai-coding-statuslines | git:main | ctx 31% | win 1,000,000 | 5h 88% left | 7d 60% left
```

**Codex:** there is no script to test. After restarting, the fields you listed should appear at the bottom of the Codex window.

If you see `command not found`, `Permission denied`, or `jq: command not found`, see [Troubleshooting](#troubleshooting).

### Step 5 — restart the agent

Quit and relaunch the agent. A status line is only read at startup.

- Codex: quit the `codex` session and start it again. Run `/status` for the detailed session view.
- Antigravity: quit and relaunch `agy`.
- Claude Code: quit and relaunch `claude`.

You should now see the status line at the bottom of the window.

---

## Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| Nothing appears | The agent was not restarted. Quit it fully and relaunch. |
| Claude status line is blank | `jq` is missing. Run `jq --version`; install it with the table above. |
| `Permission denied` | The script is not executable. Run `chmod +x "$HOME/.local/bin/claude-statusline.sh"` (or `agy-statusline.py`). |
| `command not found` | The path in `settings.json` is wrong. Run `ls -l "$HOME/.local/bin"` and use the exact path it prints. |
| Claude status line still blank | `~` was used in the command. Replace it with your full home path. |
| Codex shows nothing | `status_line` is not directly under `[tui]`. Check the section header above it. |
| Invalid JSON error | A trailing comma, a missing comma, or a duplicate key. Paste the file into `python3 -m json.tool <file>` to find the error. |
| No Git branch shown | The current folder is not a Git repository. That field is simply omitted. |
| Antigravity ignores the setting | `enabled` is false, or the `command` path is wrong. |
| Context or quota fields are missing | The agent did not include those values in its payload yet. They appear once the agent reports them. |

---

## Updating and uninstalling

The installed scripts are copies. Pulling the repository later does **not** update them. To update, re-run the `install -m 755 ...` command for your agent.

To uninstall:

1. Remove the `statusLine` block (or `status_line` line) from the agent's config file.
2. Delete the copied script if you installed one:

   ```bash
   rm -f "$HOME/.local/bin/claude-statusline.sh" "$HOME/.local/bin/agy-statusline.py"
   ```

3. Restart the agent.

Your previous config files are worth backing up before editing. For example:

```bash
cp "$HOME/.claude/settings.json" "$HOME/.claude/settings.json.backup"
```

---

## Agent guides

Each guide repeats the steps above with agent-specific details.

- [Codex](codex/README.md)
- [Google Antigravity CLI](antigravity/README.md)
- [Claude Code](claude-code/README.md)

## Usage

Restart the coding agent after installation. The status line refreshes while you work.

The scripts read only the agent's status data and local Git metadata. They do not collect telemetry or store credentials.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for ideas, testing expectations, and pull request guidance.
