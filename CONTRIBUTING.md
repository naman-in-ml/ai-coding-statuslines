# Contributing

Thanks for helping improve AI Coding Statuslines.

## What you can contribute

- Add support for another AI coding agent.
- Improve the Codex, Antigravity, or Claude Code status lines.
- Add Windows, macOS, or Linux compatibility improvements.
- Fix bugs in parsing, Git detection, formatting, or installation steps.
- Improve documentation with clearer examples.

## Before opening a pull request

1. Fork or clone the repository.
2. Create a focused branch for your change.
3. Keep scripts portable and avoid machine-specific paths.
4. Never commit credentials, tokens, private payloads, or personal paths.
5. Test the relevant script with a representative JSON payload.
6. Update the relevant README when installation or behavior changes.
7. Run the unit test suite to verify tests pass: `python3 -m unittest discover tests`.

## Pull requests

Please explain:

- What changed
- Which agent and operating systems are affected
- How you tested it
- Any limitations or follow-up work

Keep pull requests small and focused when possible.

## Security

Do not report security issues in a public issue. Contact the repository maintainer privately with a description, reproduction steps, and impact.
