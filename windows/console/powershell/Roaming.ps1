# Copies the current location to the clipboard
Function Copy-CurrentLocation()
{
	$Result = (Get-Location).Path | clip.exe
	Write-Host "Copied current location to clipboard."
	return $Result
}

# Creates a new directory and enters it
Function New-Directory([string]$Name)
{
	$Directory = New-Item -Path $Name -ItemType Directory;
	if (Test-Path $Directory)
	{
		Set-Location $Name;
	}
}

# Source location shortcuts
Function Enter-DefaultSourceLocation { Enter-SourceLocation -Provider "Default" -Path $Global:SourceLocation }
Function Enter-ProfaneClientLocation { Enter-SourceLocation -Provider "Profane Client" -Path $Global:ProfaneClientLocation }
Function Enter-ProfaneServerLocation { Enter-SourceLocation -Provider "Profane Server" -Path $Global:ProfaneServerLocation }
Function Enter-SourceLocation([string]$Provider, [string]$Path)
{
	if ([string]::IsNullOrWhiteSpace($Path))
	{
		Write-Host "The source location for $Provider have not been set."
		return
	}
	Set-Location $Path
}

Function View-On-GitHub
{
	&gh repo view --web
}

# For fun
Function Get-DadJoke
{
	# Created by @steviecoaster
	$header = @{ Accept = "application/json" }
	$joke = Invoke-RestMethod -Uri "https://icanhazdadjoke.com/" -Method Get -Headers $header 
	return $joke.joke
}

# Aliases
Set-Alias gs Enter-DefaultSourceLocation
Set-Alias client Enter-ProfaneClientLocation
Set-Alias server Enter-ProfaneServerLocation
Set-Alias open start
Set-Alias ccl Copy-CurrentLocation
Set-Alias mcd New-Directory

Set-Alias dad-joke Get-DadJoke
