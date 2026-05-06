#Requires -Version 5.1
<#
Build FixMate web, copy to backend/web, optionally commit and push.

Defaults to same-origin mode on Render:
  flutter build web --release --dart-define=FIXMATE_SAME_ORIGIN=true
#>

[CmdletBinding()]
param(
  [string]$CommitMessage = '',
  [switch]$NoCommit,
  [switch]$NoPush,
  [string]$ApiBaseUrl = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$RepoRoot = $PSScriptRoot
Set-Location -LiteralPath $RepoRoot

function Test-CommandExists {
  param([string]$Name)
  return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

if (-not (Test-CommandExists -Name 'flutter')) { throw 'flutter not found in PATH.' }
if (-not (Test-CommandExists -Name 'git')) { throw 'git not found in PATH.' }

Write-Host '==> flutter pub get' -ForegroundColor Cyan
flutter pub get

$buildArgs = @('build', 'web', '--release')
if ($ApiBaseUrl -ne '') {
  $buildArgs += ('--dart-define=API_BASE_URL=' + $ApiBaseUrl)
  Write-Host '==> Building web with API_BASE_URL' -ForegroundColor Yellow
} else {
  $buildArgs += '--dart-define=FIXMATE_SAME_ORIGIN=true'
  Write-Host '==> Building web with FIXMATE_SAME_ORIGIN=true' -ForegroundColor Green
}

Write-Host ('==> flutter ' + ($buildArgs -join ' ')) -ForegroundColor Cyan
& flutter @buildArgs

$src = Join-Path $RepoRoot 'build\web'
if (-not (Test-Path -LiteralPath $src)) { throw 'build\\web was not created. Build failed.' }

$dest = Join-Path $RepoRoot 'backend\web'
New-Item -ItemType Directory -Force -Path $dest | Out-Null

Write-Host '==> Replacing backend\\web with new build' -ForegroundColor Cyan
Get-ChildItem -LiteralPath $dest -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
Copy-Item -Path (Join-Path $src '*') -Destination $dest -Recurse -Force

Write-Host '==> backend\\web updated' -ForegroundColor Green

if ($NoCommit) {
  Write-Host 'Done (NoCommit): build + copy only.' -ForegroundColor Yellow
  exit 0
}

$pending = git -C $RepoRoot status --porcelain
if ([string]::IsNullOrWhiteSpace($pending)) {
  Write-Host 'No changes to commit.' -ForegroundColor Yellow
  exit 0
}

if ($CommitMessage -eq '') {
  $CommitMessage = ('Build web for Render - ' + (Get-Date -Format 'yyyy-MM-dd HH:mm'))
}

Write-Host '==> git add + commit' -ForegroundColor Cyan
git -C $RepoRoot add -A
git -C $RepoRoot commit -m $CommitMessage

if ($NoPush) {
  Write-Host 'Committed without push (NoPush). Run: git push' -ForegroundColor Yellow
  exit 0
}

Write-Host '==> git push' -ForegroundColor Cyan
git -C $RepoRoot push

Write-Host 'Done: build + copy + git push. Render will deploy from Git.' -ForegroundColor Green
