# chocolatey
Contains PowerShell scripts for configuring my VMs using [Chocolatey](https://chocolatey.org/).

*Note: Make sure that the execution policy is set to RemoteSigned before running one of the scripts below.*

##Development
Configures a generic development VM with all the standard tools I need. Click [here](https://github.com/pbevis/chocolatey/blob/master/dev.ps1) to view the script or run the following command to download and automatically run the script.
```powershell
iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/pbevis/chocolatey/master/dev.ps1'))
```
