# Terminal stuff

Don't run this before cloning the machine repository properly.

## Prerequisites

* [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal-preview/9n0dx20hk701) (Installed from Windows Store)

* Launch PowerShell as administrator and run the following command.

```
> Set-ExecutionPolicy Unrestricted
```

## Installation

To install, run the following script from an administrator PowerShell prompt:

```
> .\install.ps1 -PowerShellProfile -WindowsTerminalProfile -Fonts -Force
```

Or, to install everything:

```
> .\install.ps1 -All
```
