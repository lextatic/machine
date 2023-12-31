##########################################################################
# Disable UAC (temporarily)
##########################################################################

Disable-UAC

##########################################################################
# Install Ubuntu
##########################################################################

# Make sure WSL 2 is the default architecture
wsl --update
wsl --set-default-version 2

choco upgrade --cache="$ChocoCachePath" --yes wsl-ubuntu-2204 --params "/AutomaticInstall:true"

# Update Ubuntu
ubuntu run apt-get update -y
ubuntu run apt-get upgrade -y

##########################################################################
# Restore Temporary Settings
##########################################################################

Enable-UAC
Enable-MicrosoftUpdate