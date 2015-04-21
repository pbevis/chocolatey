$IsoFileUrl = "https://foundationsp.blob.core.windows.net/software/en_sql_server_2014_standard_edition_x64_dvd_3932034.iso"
$ConfigFileUrl = "https://raw.githubusercontent.com/pbevis/chocolatey/master/ConfigurationFile.ini"

$ErrorActionPreference = "Stop"

Install-WindowsFeature NET-Framework-Core

Import-Module ActiveDirectory
New-ADUser -Name "sql" -Path "CN=Users,DC=dev,DC=com" -SamAccountName "sql" -AccountPassword (ConvertTo-SecureString "Password123" -AsPlainText -Force) -ChangePasswordAtLogon:$false -Enabled $true

$tempPath = [System.IO.Path]::GetTempPath()
$isoFilePath = [System.IO.Path]::Combine($tempPath, [System.IO.Path]::GetFileName($IsoFileUrl))
$configFilePath = [System.IO.Path]::Combine($tempPath, [System.IO.Path]::GetFileName($ConfigFileUrl))

$client = New-Object System.Net.WebClient
$client.DownloadFile($IsoFileUrl, $isoFilePath) 
$client.DownloadFile($ConfigFileUrl, $configFilePath) 

$volume = Mount-DiskImage -ImagePath $isoFilePath -StorageType ISO -PassThru | Get-Volume

try
{
    Invoke-Expression "$($volume.DriveLetter):\setup.exe /ConfigurationFile=$configFilePath"
}
finally
{
    Dismount-DiskImage -ImagePath $isoFilePath -StorageType ISO
}
