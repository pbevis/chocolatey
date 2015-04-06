# chocolatey
Contains PowerShell scripts for configuring my VMs using [Chocolatey](https://chocolatey.org/).

Make sure that the execution policy is set to RemoteSigned before running one of the scripts.

##[Dev](https://github.com/pbevis/chocolatey/blob/master/dev.ps1) 

Configures a generic development VM with all the standard tools I need.
```powershell
iex ((new-object net.webclient).DownloadString('https://raw.githubusercontent.com/pbevis/chocolatey/master/dev.ps1'))
```
