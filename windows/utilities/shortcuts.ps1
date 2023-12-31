Function Set-ShortcutTarget
{
	param(
		[string]$ShortcutPath,
		[string]$NewTarget,
		[string]$Arguments
	)

	# Create a Shell COM object
	$shell = New-Object -ComObject WScript.Shell

	# Get the existing shortcut object
	$shortcut = $shell.CreateShortcut($ShortcutPath)

	# Set the TargetPath and Arguments separately
	$shortcut.TargetPath = $NewTarget
	$shortcut.Arguments = $Arguments

	# Save the changes
	$shortcut.Save()
}
