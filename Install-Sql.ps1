$IsoFileUrl = "https://foundationsp.blob.core.windows.net/software/en_sql_server_2014_standard_edition_x64_dvd_3932034.iso"
$ConfigFileUrl = "https://raw.githubusercontent.com/pbevis/chocolatey/master/ConfigurationFile.ini"

$ErrorActionPreference = "Stop"

$tempPath = [System.IO.Path]::GetTempPath()
$isoFilePath = [System.IO.Path]::Combine($tempPath, [System.IO.Path]::GetFileName($IsoFileUrl))
$configFilePath = [System.IO.Path]::Combine($tempPath, [System.IO.Path]::GetFileName($ConfigFileUrl))

Start-BitsTransfer -Source $IsoFileUrl -Destination $isoFilePath
Start-BitsTransfer -Source $ConfigFileUrl -Destination $configFilePath

$volume = Mount-DiskImage -ImagePath $isoFilePath -StorageType ISO -PassThru | Get-Volume

try
{
    Invoke-Expression "$($volume.DriveLetter):\setup.exe /IAcceptSQLServerLicenseTerms /ConfigurationFile=$configFilePath"
}
finally
{
    Dismount-DiskImage -ImagePath $isoFilePath -StorageType ISO
}
