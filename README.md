# Winget-App-Deployment

PowerShell scripts to deploy and uninstall applications using Winget.

## Usage

This repository contains two scripts:
- **Deploy-WingetApps.ps1**: Installs specified applications.
- **Uninstall-WingetApps.ps1**: Uninstalls specified applications.

## How It Works
1. The scripts read application IDs from `AppsList.txt`.
2. Each application listed in `AppsList.txt` is installed or uninstalled using Winget.
3. Applications remain private, as `AppsList.txt` is ignored in `.gitignore` and not committed to GitHub.

## Setup Instructions
1. Clone this repository:
   ```sh
   git clone https://github.com/your-github-username/Winget-App-Deployment.git
   ```
2. Navigate to the folder:
   ```sh
   cd Winget-App-Deployment
   ```
3. Create or edit `AppsList.txt` and list the applications you want to install/uninstall (one per line):
   ```
   Microsoft.VisualStudioCode
   Google.Chrome
   Mozilla.Firefox
   ```
4. Run the installation script:
   ```powershell
   .\Deploy-WingetApps.ps1
   ```
5. Run the uninstallation script:
   ```powershell
   .\Uninstall-WingetApps.ps1
   ```
6. Run the GitHub repository setup script:
   ```powershell
   .\Setup-Github-Repo.ps1
   ```
   This script will create a private repository, clone it, and push your scripts to GitHub. Note that the `--confirm` flag has been deprecated; ensure you manually confirm any necessary actions in GitHub CLI.

## Requirements
- Windows 10 or later
- PowerShell 5.1 or later
- Winget installed
- GitHub CLI installed

## GitHub Actions Workflow
This repository includes a **GitHub Actions CI/CD pipeline** that:
- **Validates the PowerShell scripts** for syntax errors.
- **Performs a dry run** to simulate installation/uninstallation.

## Contributing
1. Fork this repository.
2. Create a new branch.
3. Make your changes.
4. Submit a pull request.

## License
MIT License
