<#
.SYNOPSIS
    Installs a list of applications using Winget with optional silent mode and authentication mode.

.PARAMETER Silent
    If provided, installs applications in silent mode.

.PARAMETER AuthenticationMode
    Specifies the authentication mode to use.
    Valid values are: interactive, silentPreferred, silent.
    Defaults to interactive.

.EXAMPLE
    .\Deploy-WingetApps.ps1 -Silent -AuthenticationMode silentPreferred
#>

param (
    [switch]$Silent,
    [ValidateSet("interactive", "silentPreferred", "silent")]
    [string]$AuthenticationMode = "silent"
)

# Set execution policy for the current process
Set-ExecutionPolicy Bypass -Scope Process -Force

# Global flag for silent mode
$silentFlag = if ($Silent) { "--silent" } else { "" }

# Function to install an application via Winget
function Install-App {
    param (
        [Parameter(Mandatory)]
        [hashtable]$App
    )
    
    $appName = $App.Name
    $appID   = $App.ID
    $appOpts = $App.Options

    Write-Host "Installing: $appName" -ForegroundColor Yellow
    
    # Construct the winget command with the validated authentication mode, agreement flags, and any additional options.
    $command = "winget install --id=$appID -e --authentication-mode $AuthenticationMode --accept-package-agreements --accept-source-agreements $silentFlag $appOpts"
    Write-Host "Executing: $command"
    
    try {
        Invoke-Expression $command
        Write-Host "$appName installation initiated." -ForegroundColor Green
    }
    catch {
        Write-Host "Error installing $appName $_" -ForegroundColor Red
    }
    
    Start-Sleep -Seconds 2
}

# Array of applications to install using the original app names and package IDs
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

Write-Host "Installing applications via Winget..." -ForegroundColor Cyan

# Loop through and install each application
foreach ($app in $applications) {
    Install-App -App $app
}

Write-Host "Installations initiated. Check logs for any errors." -ForegroundColor Cyan
