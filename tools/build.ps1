<#
.SYNOPSIS
    Builds PowerBuilder 2019 targets without the IDE.

.DESCRIPTION
    Compiles each target with PBC (incremental unless -Full) and deploys the exe and PBDs
    to build\<target>\.

    PowerBuilder 2019 has no PBAutoBuild, so this script cannot refresh the PBLs from the
    ws_objects source. It builds the PBLs as they are: refresh them in the IDE first.

    PowerBuilder must not have the workspace open, because the IDE keeps the PBLs open.

.PARAMETER Target
    Target names (the .pbt file names without the extension). Default: "peat demo app".
    Separate several with commas: -Target "peat demo app,security administrator".
.PARAMETER All
    Process every .pbt in the workspace.
.PARAMETER Full
    Full instead of incremental compilation.
.PARAMETER OutDir
    Output folder. Default: build\ in the workspace.

.EXAMPLE
    pwsh -File tools\build.ps1
    pwsh -File tools\build.ps1 -Target "peat demo app,security administrator"
    pwsh -File tools\build.ps1 -All -Full

.NOTES
    Exit codes: 0 = success, 1 = a build failed, 2 = could not start (bad target,
    PowerBuilder open, PBC not found).
#>
[CmdletBinding(PositionalBinding = $false)]
param(
    [string[]]$Target = @('peat demo app'),
    [switch]$All,
    [switch]$Full,
    [string]$OutDir,
    [string]$PBC = 'C:\Program Files (x86)\Appeon\PowerBuilder 19.0\pbc190.exe'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
if (-not $OutDir) { $OutDir = Join-Path $root 'build' }
elseif (-not [IO.Path]::IsPathRooted($OutDir)) { $OutDir = Join-Path (Get-Location) $OutDir }

# PBC writes its console output in UTF-16 or UTF-8
function Read-Log([string]$Path) {
    if (-not (Test-Path $Path)) { return '' }
    $bytes = [IO.File]::ReadAllBytes($Path)
    if ($bytes.Length -gt 1 -and $bytes[1] -eq 0) { return [Text.Encoding]::Unicode.GetString($bytes) }
    return [Text.Encoding]::UTF8.GetString($bytes)
}

function Invoke-PBC([string[]]$Arguments, [string]$WorkingDirectory, [string]$ConsoleLog) {
    $process = Start-Process -FilePath $PBC -ArgumentList $Arguments -WorkingDirectory $WorkingDirectory `
        -NoNewWindow -Wait -PassThru -RedirectStandardOutput $ConsoleLog
    return $process.ExitCode
}

# --- Checks -----------------------------------------------------------------
# The 2019 workspace keeps each target in its own folder
$targets = @{}
Get-ChildItem $root -Filter *.pbt -Recurse | Where-Object { $_.FullName -notlike "$OutDir*" } |
    ForEach-Object { $targets[$_.BaseName] = $_.FullName }
$available = @($targets.Keys | Sort-Object)

$Target = @($Target | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
if ($All) { $Target = $available }
$unknown = @($Target | Where-Object { $available -notcontains $_ })
if ($unknown.Count -gt 0) {
    Write-Host "Unknown target(s): $($unknown -join ', '). Available: $($available -join ', ')"
    exit 2
}
if (Get-Process | Where-Object { $_.ProcessName -match '^PB\d{3}$' }) {
    Write-Host "Close PowerBuilder first: the IDE keeps the PBLs open."
    exit 2
}
if (-not (Test-Path $PBC)) {
    Write-Host "PBC not found: $PBC (use -PBC)"
    exit 2
}
New-Item -ItemType Directory -Force $OutDir | Out-Null
$failed = $false

# --- Build ------------------------------------------------------------------
foreach ($name in $Target) {
    $pbt = $targets[$name]
    $pbtDir = Split-Path -Parent $pbt
    $pbtText = Get-Content $pbt -Raw
    $appName = [regex]::Match($pbtText, '(?m)^appname "([^"]+)";').Groups[1].Value
    $libraries = [regex]::Match($pbtText, '(?m)^LibList "([^"]+)";').Groups[1].Value.Replace('\\', '\') -split ';'

    $targetDir = Join-Path $OutDir $name
    New-Item -ItemType Directory -Force $targetDir | Out-Null
    $exe = Join-Path $targetDir "$appName.exe"
    $log = Join-Path $targetDir 'build.log'
    $mode = if ($Full) { '/f' } else { '/i' }
    Remove-Item $exe -ErrorAction SilentlyContinue

    Write-Host "Building $name ($(if ($Full) { 'full' } else { 'incremental' }))"
    $started = Get-Date
    $rc = Invoke-PBC @('/d', "`"$pbt`"", $mode, '/o', "`"$exe`"") $pbtDir $log
    $text = Read-Log $log

    # PBC writes each PBD beside its PBL; keep them with the exe
    foreach ($library in $libraries) {
        $pbd = [IO.Path]::ChangeExtension([IO.Path]::GetFullPath((Join-Path $pbtDir $library)), '.pbd')
        if (Test-Path $pbd) { Move-Item $pbd $targetDir -Force }
    }

    if ($rc -ne 0 -or -not (Test-Path $exe)) {
        Write-Host "  Build failed (exit code $rc); see $log"
        $text -split "`r?`n" | Where-Object { $_ -match '\bError\b\s*(C\d+|:)|\bfailed\b' } | Select-Object -First 20 |
            ForEach-Object { Write-Host "  $_" }
        $failed = $true
    } else {
        Write-Host ("  {0} in {1:N0} s" -f $exe, ((Get-Date) - $started).TotalSeconds)
    }
}

if ($failed) { exit 1 }
exit 0
