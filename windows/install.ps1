[CmdletBinding(DefaultParameterSetName='prereqs')]
Param(
	[Parameter(ParameterSetName='prereqs')]
	[switch]$Prereqs,
	[Parameter(ParameterSetName='software')]
	[switch]$Ubuntu,
	[Parameter(ParameterSetName='software')]
	[switch]$Apps,
	[Parameter(ParameterSetName='software')]
	[switch]$Customization,
	[Parameter(ParameterSetName='software')]
	[switch]$VSExtensions
)

# Nothing selected? Show help screen.
if (!$Prereqs.IsPresent -and !$Ubuntu.IsPresent -and !$Apps.IsPresent `
	-and !$vsExtensions.IsPresent)
{
		-Help .\install.ps1
	Exit;
}

# Load some utilities
. (Join-Path $PSScriptRoot "./utilities/utilities.ps1")

# Assert that we're running as administrators
Assert-Administrator -FailMessage "This script must be run as administrator.";

# Install BoxStarter + Chocolatey if missing
if (!(Assert-CommandExists -CommandName "Install-BoxstarterPackage"))
{
	Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); 
		-Boxstarter -Force
}

# Check and execute parameters
if ($Prereqs.IsPresent)
{
	Install-BoxstarterPackage ./setup/prereqs.ps1 -DisableReboots
	RefreshEnv
}

if ($Apps.IsPresent)
{
	Install-BoxstarterPackage ./setup/apps.ps1 -DisableReboots
	RefreshEnv
}

if ($VSExtensions.IsPresent)
{
	Install-BoxstarterPackage ./setup/vs-extensions.ps1 -DisableReboots
	RefreshEnv
}

if ($Ubuntu.IsPresent)
{
	Install-BoxstarterPackage ./setup/ubuntu.ps1 -DisableReboots
	RefreshEnv
}

if ($Customization.IsPresent)
{
	Install-BoxstarterPackage ./setup/customization.ps1 -DisableReboots
	RefreshEnv
}