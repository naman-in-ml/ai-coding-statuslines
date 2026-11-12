#!/usr/bin/env bash
set -u
input=$(cat)
IFS=$'\x1f' read -r model effort dir cost used input_tokens window five five_reset weekly weekly_reset < <(
  printf '%s' "$input" | jq -r '[
    (.model.display_name // .model.id // "Claude"),
    (.model.reasoning_effort // .model.reasoning // ""),
    (.workspace.current_dir // .cwd // ""),
    (.cost.total_cost_usd // 0),
    ((.context_window.used_percentage // 0) | floor),
    (.context_window.total_input_tokens // 0),
    (.context_window.context_window_size // 200000),
    (.rate_limits.five_hour.used_percentage // ""),
    (.rate_limits.five_hour.resets_at // ""),
    (.rate_limits.seven_day.used_percentage // ""),
    (.rate_limits.seven_day.resets_at // "")
  ] | join("\u001f")' 2>/dev/null
)
dir=${dir:-$PWD}; model=${model:-Claude}; used=${used:-0}; window=${window:-200000}
branch=$(git -C "$dir" branch --show-current 2>/dev/null || true)
changes=$(git -C "$dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
label="$model"; [ -n "$effort" ] && label+=" ($effort)"
parts=("$label" "📁 $(basename "$dir")")
[ -n "$branch" ] && parts+=("git:$branch$( [ "$changes" -gt 0 ] 2>/dev/null && printf ' Δ%s' "$changes" )")
parts+=("ctx ${used}%" "win ${window}")
[ -n "$five" ] && parts+=("5h $(printf '%.0f' "$five")% used")
[ -n "$weekly" ] && parts+=("7d $(printf '%.0f' "$weekly")% used")
[ "$cost" != "0" ] && parts+=("$(printf '$%.2f' "$cost")")
printf '%s\n' "$(IFS=' | '; echo "${parts[*]}")"
