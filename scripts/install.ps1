$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot

$Targets = @(
  "$env:USERPROFILE\.gemini\config\skills",
  "$env:USERPROFILE\.agents\skills",
  "$env:USERPROFILE\.claude\skills"
)

foreach ($Target in $Targets) {
  if (-not (Test-Path $Target)) {
    New-Item -ItemType Directory -Force -Path $Target | Out-Null
  }
  Copy-Item -Recurse -Force "$RepoRoot\skills\cloudflare-workers-d1" "$Target\cloudflare-workers-d1"
  Copy-Item -Recurse -Force "$RepoRoot\skills\cloudflare-workers-d1-en" "$Target\cloudflare-workers-d1-en"
  Write-Host "✅ Installed Cloudflare skills to: $Target" -ForegroundColor Green
}

Write-Host "`n🎉 Installation complete! Open a new chat to use /cloudflare-workers-d1 or /cloudflare-workers-d1-en." -ForegroundColor Cyan
