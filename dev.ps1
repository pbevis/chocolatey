Write-Host "Installing Chocolatey"
iex ((new-object net.webclient).DownloadString('http://bit.ly/psChocInstall'))
Write-Host
 
Write-Host "Installing applications from Chocolatey"
cinst git
cinst notepadplusplus
cinst Firefox
cinst GoogleChrome
cinst fiddler4
cinst winmerge
cinst ruby
