# Claude Code status line for Windows PowerShell.
$inputJson = [Console]::In.ReadToEnd() | ConvertFrom-Json
$model = if ($inputJson.model.display_name) { $inputJson.model.display_name } else { $inputJson.model.id }
if (-not $model) { $model = "Claude" }
$effort = $inputJson.model.reasoning_effort
if (-not $effort) { $effort = $inputJson.model.reasoning }
$dir = $inputJson.workspace.current_dir
if (-not $dir) { $dir = $inputJson.cwd }
if (-not $dir) { $dir = (Get-Location).Path }

$branch = ""
$changes = 0
try {
  $branch = (git -C $dir branch --show-current 2>$null).Trim()
  $changes = @(git -C $dir status --porcelain 2>$null).Count
} catch { }

$label = $model
if ($effort) { $label += " ($effort)" }
$parts = [System.Collections.Generic.List[string]]::new()
$parts.Add($label)
$parts.Add("📁 " + (Split-Path $dir -Leaf))
if ($branch) {
  $gitLabel = "git:$branch"
  if ($changes -gt 0) { $gitLabel += " Δ$changes" }
  $parts.Add($gitLabel)
}

$context = $inputJson.context_window
$used = if ($null -ne $context.used_percentage) { [math]::Floor($context.used_percentage) } else { 0 }
$window = if ($context.context_window_size) { $context.context_window_size } else { 200000 }
$parts.Add("ctx ${used}%")
$parts.Add("win $window")

if ($null -ne $inputJson.rate_limits.five_hour.used_percentage) {
  $parts.Add("5h " + [math]::Round($inputJson.rate_limits.five_hour.used_percentage) + "% used")
}
if ($null -ne $inputJson.rate_limits.seven_day.used_percentage) {
  $parts.Add("7d " + [math]::Round($inputJson.rate_limits.seven_day.used_percentage) + "% used")
}
if ($inputJson.cost.total_cost_usd) {
  $parts.Add(("{0:C2}" -f $inputJson.cost.total_cost_usd))
}

[Console]::WriteLine(($parts -join " | "))
