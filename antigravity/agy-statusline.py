#!/usr/bin/env python3
"""Portable Antigravity CLI status line."""
import json
import os
import subprocess
import sys


def git_info(cwd):
    try:
        branch = subprocess.check_output(["git", "-C", cwd, "branch", "--show-current"], text=True, stderr=subprocess.DEVNULL).strip()
        if not branch:
            sha = subprocess.check_output(["git", "-C", cwd, "rev-parse", "--short", "HEAD"], text=True, stderr=subprocess.DEVNULL).strip()
            if sha:
                branch = f":{sha}"
        changes = subprocess.check_output(["git", "-C", cwd, "status", "--porcelain"], text=True, stderr=subprocess.DEVNULL).splitlines()
        return branch, len(changes)
    except (OSError, subprocess.SubprocessError):
        return "", 0


def pct(value):
    return f"{value * 100:.0f}%" if isinstance(value, (int, float)) else "—"


def main():
    try:
        data = json.load(sys.stdin) if not sys.stdin.isatty() else {}
    except (json.JSONDecodeError, ValueError):
        data = {}
    if not isinstance(data, dict):
        data = {}

    model = data.get("model") if isinstance(data.get("model"), dict) else {}
    name = model.get("display_name") or model.get("id") or "Antigravity"
    effort = model.get("effort")
    if effort:
        name += f" ({effort})"
    workspace = data.get("workspace") if isinstance(data.get("workspace"), dict) else {}
    cwd = data.get("cwd") or workspace.get("current_dir") or os.getcwd()
    branch, changes = git_info(cwd)
    context = data.get("context_window") if isinstance(data.get("context_window"), dict) else {}
    quota = data.get("quota") if isinstance(data.get("quota"), dict) else {}

    five_entry = quota.get("gemini-5h")
    five = five_entry.get("remaining_fraction") if isinstance(five_entry, dict) else None

    weekly_entry = quota.get("gemini-weekly")
    weekly = weekly_entry.get("remaining_fraction") if isinstance(weekly_entry, dict) else None

    parts = [name, f"📁 {os.path.basename(cwd) or cwd}"]
    if branch:
        parts.append(f"git:{branch}" + (f" Δ{changes}" if changes else ""))
    if isinstance(context.get("used_percentage"), (int, float)):
        parts.append(f"ctx {context['used_percentage']:.0f}%")
    if context.get("context_window_size"):
        parts.append(f"win {context['context_window_size']:,}")
    if five is not None:
        parts.append(f"5h {pct(five)} left")
    if weekly is not None:
        parts.append(f"7d {pct(weekly)} left")
    print(" | ".join(parts))


if __name__ == "__main__":
    main()
