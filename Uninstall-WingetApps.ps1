<#
.SYNOPSIS
    Uninstalls a list of applications using Winget with optional silent mode.
.PARAMETER Silent
    If provided, uninstalls applications in silent mode.
.EXAMPLE
    .\Uninstall-WingetApps.ps1 -Silent
#>

param (
    [switch]$Silent
)

# Set execution policy for the current process
Set-ExecutionPolicy Bypass -Scope Process -Force

# Global flag for silent mode
$silentFlag = if ($Silent) { "--silent" } else { "" }

# Function to uninstall an application via Winget
function Uninstall-App {
    param (
        [Parameter(Mandatory)]
        [hashtable]$App
    )
    
    $appName = $App.Name
    $appID   = $App.ID
    $appOpts = $App.Options

    Write-Host "Uninstalling: $appName" -ForegroundColor Yellow
    
    # Construct the winget command with agreement flags and any additional options
    $command = "winget uninstall --id=$appID -e --accept-source-agreements $silentFlag $appOpts"
    Write-Host "Executing: $command"
    
    try {
        Invoke-Expression $command
        Write-Host "$appName uninstallation initiated." -ForegroundColor Green
    }
    catch {
        Write-Host "Error uninstalling $appName $_" -ForegroundColor Red
    }
    
    Start-Sleep -Seconds 2
}

# Array of applications to uninstall (using the original app names and corresponding package IDs)
$applications = @(
    @{ Name = "Google Chrome";       ID = "Google.Chrome";                        Options = "" },
    @{ Name = "Visual Studio";       ID = "Microsoft.VisualStudio.2022.Community"; Options = "" },
    @{ Name = "Visual Studio Code";  ID = "Microsoft.VisualStudioCode";           Options = "" },
    @{ Name = "Adobe";               ID = "Adobe.Acrobat.Reader.DC";              Options = "" },
    @{ Name = "Box";                 ID = "Box.Box";                              Options = "" },
    @{ Name = "Box Tools";           ID = "Box.BoxTools";                         Options = "" },
    @{ Name = "Zoom";                ID = "Zoom.Zoom";                            Options = "" },
    @{ Name = "TeamViewer";          ID = "TeamViewer.TeamViewer";                Options = "" },
    @{ Name = "ChatGPT";             ID = "ChatGPTDesktop.ChatGPTDesktop";        Options = "" },
    @{ Name = "PowerToys";           ID = "Microsoft.PowerToys";                  Options = "" },
    @{ Name = "Microsoft PowerBI Desktop"; ID = "Microsoft.PowerBI";              Options = "" }
    @{ Name = "PowerShell";          ID = "9MZ1SNWT0N5D";                         Options = "" }
)

Write-Host "Uninstalling applications via Winget..." -ForegroundColor Cyan

# Loop through and uninstall each application
foreach ($app in $applications) {
    Uninstall-App -App $app
}

Write-Host "Uninstallations initiated. Check logs for any errors." -ForegroundColor Cyan
