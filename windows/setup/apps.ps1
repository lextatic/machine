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
# Install applications
##########################################################################

# Essentials
choco upgrade --cache="$ChocoCachePath" --yes 7zip
choco upgrade --cache="$ChocoCachePath" --yes chocolateygui
choco upgrade --cache="$ChocoCachePath" --yes powertoys
choco upgrade --cache="$ChocoCachePath" --yes procexp
choco upgrade --cache="$ChocoCachePath" --yes x-mouse-button-control
choco upgrade --cache="$ChocoCachePath" --yes obsidian

# Browsers
choco upgrade --cache="$ChocoCachePath" --yes brave
choco upgrade --cache="$ChocoCachePath" --yes firefox

# Hardware specifics
choco upgrade --cache="$ChocoCachePath" --yes geforce-experience
#choco upgrade --cache="$ChocoCachePath" --yes via

# Hardware monitoring
choco upgrade --cache="$ChocoCachePath" --yes crystaldiskinfo
choco upgrade --cache="$ChocoCachePath" --yes defraggler
choco upgrade --cache="$ChocoCachePath" --yes openhardwaremonitor
choco upgrade --cache="$ChocoCachePath" --yes wiztree

# Media
choco upgrade --cache="$ChocoCachePath" --yes mpc-hc
choco upgrade --cache="$ChocoCachePath" --yes spotify

# Content creation
choco upgrade --cache="$ChocoCachePath" --yes audacity
choco upgrade --cache="$ChocoCachePath" --yes carnac
choco upgrade --cache="$ChocoCachePath" --yes inkscape
choco upgrade --cache="$ChocoCachePath" --yes obs-studio
choco upgrade --cache="$ChocoCachePath" --yes paint.net
choco upgrade --cache="$ChocoCachePath" --yes screentogif
choco upgrade --cache="$ChocoCachePath" --yes sharex
choco upgrade --cache="$ChocoCachePath" --yes shotcut

# Gaming
choco upgrade --cache="$ChocoCachePath" --yes steam
choco upgrade --cache="$ChocoCachePath" --yes ps-remote-play
#choco upgrade --cache="$ChocoCachePath" --yes epicgameslauncher

# Comms
choco upgrade --cache="$ChocoCachePath" --yes discord

# GameDev tools
choco upgrade --cache="$ChocoCachePath" --yes dotpeek --pre
choco upgrade --cache="$ChocoCachePath" --yes gh # GitHub CLI
choco upgrade --cache="$ChocoCachePath" --yes git
#choco upgrade --cache="$ChocoCachePath" --yes git-fork #currently broken
choco upgrade --cache="$ChocoCachePath" --yes grepwin
choco upgrade --cache="$ChocoCachePath" --yes gsudo
choco upgrade --cache="$ChocoCachePath" --yes klogg
choco upgrade --cache="$ChocoCachePath" --yes notepadplusplus
choco upgrade --cache="$ChocoCachePath" --yes poshgit
choco upgrade --cache="$ChocoCachePath" --yes powershell-core
choco upgrade --cache="$ChocoCachePath" --yes unity-hub
#choco upgrade --cache="$ChocoCachePath" --yes visualstudio2022community --package-parameters "--add Microsoft.VisualStudio.Workload.ManagedDesktop --add Microsoft.VisualStudio.Workload.ManagedGame --includeRecommended --norestart --passive --locale en-US"

# INSANE work tools
choco upgrade --cache="$ChocoCachePath" --yes cloudberryexplorer.amazons3
choco upgrade --cache="$ChocoCachePath" --yes pritunl-client

# Others
choco upgrade --cache="$ChocoCachePath" --yes qbittorrent

##########################################################################
# Install posh-git
##########################################################################

PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force

##########################################################################
# Install terminal icons
##########################################################################

PowerShellGet\Install-Module -Name Terminal-Icons -Repository PSGallery

##########################################################################
# Restore Temporary Settings
##########################################################################

Enable-UAC
Enable-MicrosoftUpdate