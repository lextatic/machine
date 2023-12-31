Function Install-RemoteFile
{
	[CmdletBinding()]
	param(
		[string]$Url,
		[string]$Filename,
		[string]$Arguments,
		[switch]$RefreshEnvVars
	)

	$DownloadDirectory = "$HOME/Downloads";
	$DownloadedFile = "$DownloadDirectory/$Filename";

	# Download the file
	$Client = New-Object System.Net.WebClient;
	$Client.DownloadFile($Url, $DownloadedFile);

	# Run the file.
	Start-Process -FilePath $DownloadedFile -NoNewWindow -Wait -ArgumentList $Arguments;

	# Refresh environemnt variables?
	if ($RefreshEnvVars.IsPresent)
	{
		RefreshEnv | Out-Null;
	}
}

Function Install-RemoteFileFromGitHub
{
	[CmdletBinding()]
	param(
		[string]$GitHubUser,
		[string]$GitHubRepo,
		[string]$AssetName,
		[string]$Arguments,
		[switch]$RefreshEnvVars
	)

	# Compose the GitHub release URL
	$Url = "https://api.github.com/repos/$GitHubUser/$GitHubRepo/releases/latest"
	$LatestRelease = Invoke-RestMethod -Uri $Url

	# Find the asset by name
	$LatestAsset = $LatestRelease.assets | Where-Object { $_.name -eq $AssetName }

	if ($LatestAsset -eq $null) {
		Write-Host "Asset not found: $AssetName"
		return
	}

	# Extract the filename and download URL
	$LatestAssetUrl = $LatestAsset.browser_download_url
	$Filename = $LatestAsset.name

	# Download and install the file using the original function
	Install-RemoteFile -Url $LatestAssetUrl -Filename $Filename -Arguments $Arguments -RefreshEnvVars
}
