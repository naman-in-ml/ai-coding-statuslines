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

## Installation

Clone the repository:

```bash
git clone https://github.com/naman-in-ml/ai-coding-statuslines.git
cd ai-coding-statuslines
```

Choose your coding agent:

- [Codex](codex/README.md)
- [Google Antigravity CLI](antigravity/README.md)
- [Claude Code](claude-code/README.md)

## Usage

Follow the guide for your agent. Each guide explains where to copy the status-line script or configuration and how to enable it.

Restart the coding agent after installation. The status line will refresh while you work.

The scripts read only the agent's status data and local Git metadata. They do not collect telemetry or store credentials.
