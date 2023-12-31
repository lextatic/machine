##########################################################################
# Install VSCode extensions
##########################################################################

Function Install-VSExtension([String] $PackageName) 
{
	# Based on https://gist.github.com/ScottHutchinson/b22339c3d3688da5c9b477281e258400
	$Uri = "https://marketplace.visualstudio.com/items?itemName=$($PackageName)"
	$VsixLocation = "$($env:Temp)\$([guid]::NewGuid()).vsix"   
	$VSInstallDir = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\resources\app\ServiceHub\Services\Microsoft.VisualStudio.Setup.Service"

	if (-Not $VSInstallDir)
	{
		Write-Error "Visual Studio InstallDir registry key missing" -ForegroundColor Red
		Exit 1
	}
	
	Write-Host "Grabbing VSIX extension at $($Uri)"
	$HTML = Invoke-WebRequest -Uri $Uri -UseBasicParsing -SessionVariable session
	
	Write-Debug "Attempting to download $($PackageName)..."
	$anchor = $HTML.Links |
	Where-Object { $_.class -eq 'install-button-container' } |
	Select-Object -ExpandProperty href

	if (-Not $anchor)
	{
		Write-Error "Could not find download anchor tag on the Visual Studio Extensions page" -ForegroundColor Red
		Exit 1
	}

	$href = "https://marketplace.visualstudio.com$($anchor)"
	Write-Debug "Anchor is $($anchor)"
	Write-Debug "Href is $($href)"
	
	Invoke-WebRequest $href -OutFile $VsixLocation -WebSession $session
	if (-Not (Test-Path $VsixLocation))
	{
		Write-Error "Downloaded VSIX file could not be located" -ForegroundColor Red
		Exit 1
	}

	Write-Debug "VSInstallDir is $($VSInstallDir)"
	Write-Debug "VsixLocation is $($VsixLocation)"
	Write-Host "Installing $($PackageName)..."
	Start-Process -Filepath "$($VSInstallDir)\VSIXInstaller" -ArgumentList "/q /a $($VsixLocation)" -Wait
	
	Write-Debug "Cleanup..."
	Remove-Item $VsixLocation
	
	Write-Host "Installation of $($PackageName) complete!" -ForegroundColor Green
}

Write-Host "Installing Visual Studio extensions" -ForegroundColor Yellow
Write-Host "NOTE: Script might appear unresponsive"

Install-VSExtension -PackageName "PaulHarrington.EditorGuidelinesPreview"
Install-VSExtension -PackageName "MadsKristensen.CodeCleanupOnSave"