<#
.SYNOPSIS
    Installs applications from AppsList.txt using Winget.

.DESCRIPTION
    Reads application IDs from AppsList.txt and installs them via Winget.
    Each line should contain: AppID | DisplayName (optional)
    Lines starting with # are treated as comments.

.PARAMETER Silent
    If provided, installs applications in silent mode.

.PARAMETER AuthenticationMode
    Specifies the authentication mode: interactive, silentPreferred, silent.
    Defaults to silent.

.PARAMETER AppsFile
    Path to the apps list file. Defaults to AppsList.txt in script directory.

.EXAMPLE
    .\Deploy-WingetApps.ps1
    .\Deploy-WingetApps.ps1 -Silent -AuthenticationMode silentPreferred
    .\Deploy-WingetApps.ps1 -AppsFile "C:\MyApps.txt"
#>

param (
    [switch]$Silent,
    [ValidateSet("interactive", "silentPreferred", "silent")]
    [string]$AuthenticationMode = "silent",
    [string]$AppsFile = (Join-Path $PSScriptRoot "AppsList.txt")
)

# Set execution policy for the current process
Set-ExecutionPolicy Bypass -Scope Process -Force

# Validate apps file exists
if (-not (Test-Path $AppsFile)) {
    Write-Host "Error: Apps list file not found: $AppsFile" -ForegroundColor Red
    Write-Host "Create AppsList.txt with one app ID per line. See AppsList.example.txt for format." -ForegroundColor Yellow
    exit 1
}

# Global flag for silent mode
$silentFlag = if ($Silent) { "--silent" } else { "" }

function Install-App {
    param (
        [Parameter(Mandatory)]
        [string]$AppID,
        [string]$AppName = $AppID
    )

    Write-Host "`nInstalling: $AppName ($AppID)" -ForegroundColor Yellow

    $command = "winget install --id=`"$AppID`" -e --authentication-mode $AuthenticationMode --accept-package-agreements --accept-source-agreements $silentFlag"
    Write-Host "Executing: $command" -ForegroundColor Gray

    try {
        Invoke-Expression $command
        if ($LASTEXITCODE -eq 0) {
            Write-Host "$AppName installed successfully." -ForegroundColor Green
        } else {
            Write-Host "$AppName installation may have issues (exit code: $LASTEXITCODE)" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Error installing $AppName : $_" -ForegroundColor Red
    }

    Start-Sleep -Seconds 1
}

# Read and parse apps file
Write-Host "Reading apps from: $AppsFile" -ForegroundColor Cyan
$apps = Get-Content $AppsFile | Where-Object { 
    $_.Trim() -and -not $_.StartsWith('#') 
}

if ($apps.Count -eq 0) {
    Write-Host "No applications found in $AppsFile" -ForegroundColor Yellow
    exit 0
}

Write-Host "Found $($apps.Count) application(s) to install" -ForegroundColor Cyan

foreach ($line in $apps) {
    $parts = $line -split '\|'
    $appID = $parts[0].Trim()
    $appName = if ($parts.Count -gt 1) { $parts[1].Trim() } else { $appID }
    
    Install-App -AppID $appID -AppName $appName
}

Write-Host "`nInstallation complete. Check output for any errors." -ForegroundColor Cyan
