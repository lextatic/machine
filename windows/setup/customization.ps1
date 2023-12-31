##########################################################################
# Disable UAC (temporarily)
##########################################################################

Disable-UAC

##########################################################################
# Create temporary directory
##########################################################################

# Workaround choco / boxstarter path too long error
# https://github.com/chocolatey/boxstarter/issues/241
$ChocoCachePath = "$env:USERPROFILE\AppData\Local\Temp\chocolatey"
New-Item -Path $ChocoCachePath -ItemType Directory -Force

##########################################################################
# Install Windows customization applications
##########################################################################

# Download and install Explorer Patcher
Install-RemoteFileFromGitHub -GitHubUser 'valinet' -GitHubRepo 'ExplorerPatcher' -AssetName 'ep_setup.exe' -Arguments '/S' -RefreshEnvVars

# 7+ Taskbar Tweaker
choco upgrade --cache="$ChocoCachePath" --yes 7tt

##########################################################################
# Load my custom configs
##########################################################################

# ExplorerPatcher configs
$regFilePath = "config/ExplorerPatcher.reg"
Start-Process regedit.exe -ArgumentList "/s $regFilePath" -Wait

# 7+ Taskbar Tweaker configs
$regFilePath = "config/7+TaskbarTweaker.reg"
Start-Process regedit.exe -ArgumentList "/s $regFilePath" -Wait

# Force Explorer to restart
Stop-Process -Name explorer -Force

##########################################################################
# Restore Temporary Settings
##########################################################################

Enable-UAC
Enable-MicrosoftUpdate