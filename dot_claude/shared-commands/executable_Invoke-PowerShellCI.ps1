#!/usr/bin/pwsh
#Requires -Version 7.0
<#
.SYNOPSIS
    Local equivalent of the "00 - PowerShell CI" GitHub Actions workflow
    (A00-lint-and-syntax job).

.DESCRIPTION
    1. Ensures PSScriptAnalyzer is installed.
    2. Runs Invoke-ScriptAnalyzer recursively (fails on any diagnostic, like -EnableExit).
    3. Parses every .ps1/.psm1 file for syntax errors.

.PARAMETER Path
    Root path to scan. Defaults to current directory (mirrors checkout root).

.PARAMETER Severity
    Diagnostic severities that should fail the run. Defaults to all
    (Error, Warning, Information) to match -EnableExit's default behavior
    of exiting non-zero on any diagnostic.

.EXAMPLE
    ./Invoke-PowerShellCI.ps1

.EXAMPLE
    ./Invoke-PowerShellCI.ps1 -Path ./src -Severity Error,Warning
#>
[CmdletBinding()]
param(
    [string]$Path = '.',
    [string[]]$Severity = @('Error', 'Warning', 'Information')
)

$ErrorActionPreference = 'Stop'
$exitCode = 0

function Write-Section {
    param([string]$Title)
    Write-Host ''
    Write-Host "==== $Title ====" -ForegroundColor Cyan
}

# ---------------------------------------------------------------------------
# Step 1: Install PSScriptAnalyzer (skip if already present)
# ---------------------------------------------------------------------------
Write-Section 'Install PSScriptAnalyzer'
if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force
}
else {
    Write-Host 'PSScriptAnalyzer already installed, skipping install.'
}
Import-Module PSScriptAnalyzer -ErrorAction Stop

# ---------------------------------------------------------------------------
# Step 2: Run PSScriptAnalyzer
# ---------------------------------------------------------------------------
Write-Section 'Run PSScriptAnalyzer'
$analyzerResults = Invoke-ScriptAnalyzer -Path $Path -Recurse -Severity $Severity

if ($analyzerResults) {
    $analyzerResults | Format-Table -AutoSize
    Write-Host "PSScriptAnalyzer found $($analyzerResults.Count) diagnostic(s)." -ForegroundColor Red
    $exitCode = 1
}
else {
    Write-Host 'PSScriptAnalyzer: no diagnostics found.' -ForegroundColor Green
}

# ---------------------------------------------------------------------------
# Step 3: Validate PowerShell syntax
# ---------------------------------------------------------------------------
Write-Section 'Validate PowerShell syntax'
$files = Get-ChildItem -Path $Path -Recurse -Include *.ps1, *.psm1 -File
$syntaxErrorsFound = $false

foreach ($file in $files) {
    Write-Host "Parsing $($file.FullName)"
    $tokens = $null
    $parseErrors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)

    if ($parseErrors -and $parseErrors.Count -gt 0) {
        foreach ($parseError in $parseErrors) {
            Write-Host "Syntax error in $($file.FullName): $($parseError.Message)" -ForegroundColor Red
        }
        $syntaxErrorsFound = $true
    }
}

if ($syntaxErrorsFound) {
    Write-Host 'Syntax errors detected.' -ForegroundColor Red
    $exitCode = 1
}
else {
    Write-Host 'No syntax errors detected.' -ForegroundColor Green
}

# ---------------------------------------------------------------------------
# Result
# ---------------------------------------------------------------------------
Write-Section 'Result'
if ($exitCode -ne 0) {
    Write-Host 'CI check FAILED.' -ForegroundColor Red
}
else {
    Write-Host 'CI check PASSED.' -ForegroundColor Green
}

exit $exitCode
