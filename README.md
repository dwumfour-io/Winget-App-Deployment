# Winget-App-Deployment

PowerShell scripts to deploy and uninstall applications using Windows Package Manager (Winget).

## Features

- 📦 Bulk install/uninstall apps from a simple text file
- 🔇 Silent mode support for automated deployments
- 💬 Optional display names for clearer output
- 🔐 Configurable authentication modes
- ✅ Keeps your app list private (not committed to git)

## Quick Start

1. **Clone this repository:**
   ```powershell
   git clone https://github.com/dwumfour-io/Winget-App-Deployment.git
   cd Winget-App-Deployment
   ```

2. **Create your apps list:**
   ```powershell
   # Copy the example file
   Copy-Item AppsList.example.txt AppsList.txt
   
   # Edit with your desired apps
   notepad AppsList.txt
   ```

3. **Run the installer:**
   ```powershell
   .\Deploy-WingetApps.ps1
   ```

## AppsList.txt Format

```text
# Lines starting with # are comments
# Format: AppID | Display Name (optional)

Google.Chrome | Google Chrome
Microsoft.VisualStudioCode | VS Code
Mozilla.Firefox
```

## Usage Examples

```powershell
# Install all apps from AppsList.txt
.\Deploy-WingetApps.ps1

# Install silently (no prompts)
.\Deploy-WingetApps.ps1 -Silent

# Use a different apps file
.\Deploy-WingetApps.ps1 -AppsFile "C:\MyApps.txt"

# Uninstall all apps
.\Uninstall-WingetApps.ps1

# Uninstall silently
.\Uninstall-WingetApps.ps1 -Silent
```

## Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `-Silent` | Suppress installation prompts | False |
| `-AuthenticationMode` | interactive, silentPreferred, silent | silent |
| `-AppsFile` | Path to apps list file | AppsList.txt |

## Finding App IDs

Search for apps using Winget:
```powershell
winget search "chrome"
winget search "visual studio"
```

## License

MIT License - see [LICENSE](LICENSE) for details.
