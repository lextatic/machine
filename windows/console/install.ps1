[CmdletBinding(DefaultParameterSetName='Granular')]
Param(
	[Parameter(ParameterSetName='All')]
	[switch]$All,
	[Parameter(ParameterSetName='Granular')]
	[switch]$PowerShellProfile,
	[Parameter(ParameterSetName='Granular')]
	[switch]$Fonts,
	[Parameter(ParameterSetName='Granular')]
	[switch]$WindowsTerminalProfile,
	[switch]$Force
)

. (Join-Path $PSScriptRoot "../utilities/fonts.ps1")
. (Join-Path $PSScriptRoot "../utilities/shortcuts.ps1")
. (Join-Path $PSScriptRoot "../utilities/store.ps1")
. (Join-Path $PSScriptRoot "../utilities/terminal.ps1")
. (Join-Path $PSScriptRoot "../utilities/utilities.ps1")

# Nothing selected? Show help screen.
if (!$PowerShellProfile.IsPresent -and !$Fonts.IsPresent -and !$WindowsTerminalProfile.IsPresent `
	-and !$OhMyPosh.IsPresent -and !$All.IsPresent)
{
	Get-Help .\install.ps1
	Exit;
}

#################################################################
# POWERSHELL
#################################################################

if($All.IsPresent -or $PowerShellProfile.IsPresent)
{
	if(!(Test-Path $PROFILE) -or $Force.IsPresent -or $All.IsPresent)
	{
		# Update PowerShell profile
		Write-Host "Adding PowerShell profile...";
		$MachinePath = (Get-Item (Join-Path $PSScriptRoot "../../")).FullName
		$PowerShellProfileTemplatePath = Join-Path $PSScriptRoot "powershell/Profile.template";
		$PowerShellProfilePath = (Join-Path $PSScriptRoot "powershell/Roaming.ps1");
		$PowerShellPromptPath = (Join-Path $PSScriptRoot "powershell/Prompt.ps1");
		$PowerShellLocalProfilePath = Join-Path (Get-Item $PROFILE).Directory.FullName "LocalProfile.ps1"
		Copy-Item -Path $PowerShellProfileTemplatePath -Destination $PROFILE;
		
		# Replace placeholder values
		(Get-Content -path $PROFILE -Raw) -Replace '<<MACHINE>>', $MachinePath | Set-Content -Path $PROFILE
		(Get-Content -path $PROFILE -Raw) -Replace '<<PROFILE>>', $PowerShellProfilePath | Set-Content -Path $PROFILE
		(Get-Content -path $PROFILE -Raw) -Replace '<<PROMPT>>', $PowerShellPromptPath | Set-Content -Path $PROFILE
		(Get-Content -path $PROFILE -Raw) -Replace '<<LOCALPROFILE>>', $PowerShellLocalProfilePath | Set-Content -Path $PROFILE
		
		# Unblocks the file so it runs without prompts on Terminal
		$profilePath = Join-Path $env:USERPROFILE 'Documents/PowerShell/Microsoft.PowerShell_profile.ps1'
		Unblock-File -LiteralPath $profilePath
	}
	else
	{
		Write-Host "PowerShell profile already exist.";
		Write-Host "Use the -Force switch to overwrite.";
	}
}

#################################################################
# WINDOWS TERMINAL
#################################################################

if($All.IsPresent -or $WindowsTerminalProfile.IsPresent)
{
	Assert-Administrator -FailMessage "Installing Windows Terminal profile requires administrator privilegies.";
	Assert-WindowsTerminalInstalled;

	# Create symlink to Windows Terminal settings
	$TerminalProfileSource = Join-Path $PWD "../configs/windows_terminal.json"
	$TerminalPath = Get-WindowsStoreAppPath -App "Microsoft.WindowsTerminal_8wekyb3d8bbwe";
	$TerminalProfileDestination = Join-Path $TerminalPath "LocalState/settings.json";
	if(Test-Path $TerminalProfileDestination)
	{
		Remove-Item -Path $TerminalProfileDestination;
	}

	Write-Host "Creating symlink to Windows terminal settings..."
	New-Item -Path $TerminalProfileDestination -ItemType SymbolicLink -Value $TerminalProfileSource | Out-Null;

	# Set a user environment variable that contains the path to console images
	Write-Host "Setting environment 'WINDOWSTERMINAL_IMAGES' variable..."
	$ImagesPath = Join-Path $PWD "terminal/images";
	[Environment]::SetEnvironmentVariable("WINDOWSTERMINAL_IMAGES", "$ImagesPath", "User")

	Write-Host "Setting environment 'WINDOWSTERMINAL_ICONS' variable..."
	$IconsPath = Join-Path $PWD "terminal/icons";
	[Environment]::SetEnvironmentVariable("WINDOWSTERMINAL_ICONS", "$IconsPath", "User")

	Write-Host "Setting environment 'WINDOWSTERMINAL_SHADERS' variable..."
	$ShadersPath = Join-Path $PWD "terminal/shaders";
	[Environment]::SetEnvironmentVariable("WINDOWSTERMINAL_SHADERS", "$ShadersPath", "User")
	
	# Set Explorer context menu "Open Git Bash here" to be compatible with my Windows Terminal config
	Set-ItemProperty -Path 'HKLM:\Software\Classes\Directory\Background\shell\git_shell\command' -Name '(Default)' -Value '"C:\Program Files\Git\usr\bin\bash.exe" --login -i'

	# Update Developer Command Prompt shortcut target so it works with Windows Terminal
	$ShortcutPath = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio 2022\Visual Studio Tools\Developer Command Prompt for VS 2022.lnk'
	$NewTarget = 'C:\Windows\System32\cmd.exe'
	$Arguments = '/k ""C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat""'
	Set-ShortcutTarget -ShortcutPath $ShortcutPath -NewTarget $NewTarget -Arguments $Arguments
	
	# Update Developer PowerShell shortcut target so it works with Windows Terminal
	$ShortcutPath = 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Visual Studio 2022\Visual Studio Tools\Developer PowerShell for VS 2022.lnk'
	$NewTarget = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
	$Arguments = '-NoExit -Command "&{Import-Module """C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"""; Enter-VsDevShell 9e11e02c}"'
	Set-ShortcutTarget -ShortcutPath $ShortcutPath -NewTarget $NewTarget -Arguments $Arguments
}

#################################################################
# FONTS
#################################################################

if($All.IsPresent -or $Fonts.IsPresent)
{
	# Install CaskaydiaMono font
	Write-Host "Installing CaskaydiaMono nerd font..."
	$FontPath = Join-Path $PWD "fonts/CaskaydiaMonoNerdFont-Regular.ttf";
	Install-Font -FontPath $FontPath;
}
