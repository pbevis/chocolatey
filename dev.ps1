Write-Host "Installing Chocolatey..."
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

Write-Host "Installing applications from Chocolatey..."
choco install 7zip -y
choco install git -y
choco install notepadplusplus -y
choco install Firefox -y
choco install GoogleChrome -y
choco install fiddler4 -y
choco install winmerge -y
choco install windowsazurepowershell -y
choco install vagrant -y

Write-Host "Installing vagrant plugins..."
C:\HashiCorp\Vagrant\bin\vagrant plugin install vagrant-azure
