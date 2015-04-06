Write-Host "Installing Chocolatey"
iex ((new-object net.webclient).DownloadString('http://bit.ly/psChocInstall'))

Write-Host "Installing applications from Chocolatey"
cinst git -y
cinst notepadplusplus -y
cinst Firefox -y
cinst GoogleChrome -y
cinst fiddler4 -y
cinst winmerge -y
cinst windowsazurepowershell -y
