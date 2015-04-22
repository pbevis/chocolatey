$FileUrl = "https://raw.githubusercontent.com/pbevis/chocolatey/master/TestAccounts.csv"

$ErrorActionPreference = "Stop"

Import-Module ActiveDirectory
$dn = (Get-ADDomain).DistinguishedName
$forest = (Get-ADDomain).Forest

$ou = Get-ADOrganizationalUnit -Filter 'name -eq "Test Users"'
if($ou -eq $null) {
    New-ADOrganizationalUnit -Name "Test Users" -Path $dn
    $ou = Get-ADOrganizationalUnit -Filter 'name -eq "Test Users"'
}

$tempPath = [System.IO.Path]::GetTempPath()
$filePath = [System.IO.Path]::Combine($tempPath, [System.IO.Path]::GetFileName($FileUrl))

$client = New-Object System.Net.WebClient
$client.DownloadFile($FileUrl, $filePath) 

$data = Import-Csv $filePath

$users = $data | select  @{Name="Name";Expression={$_.Surname + ", " + $_.GivenName}},`
         @{Name="SamAccountName"; Expression={$_.Username}},`
         @{Name="UserPrincipalName"; Expression={$_.Username + "@" + $forest}},`
         @{Name="GivenName"; Expression={$_.GivenName}},`
         @{Name="Surname"; Expression={$_.Surname}},`
         @{Name="DisplayName"; Expression={$_.Surname + ", " + $_.GivenName}},`
         @{Name="City"; Expression={$_.City}},`
         @{Name="StreetAddress"; Expression={$_.StreetAddress}},`
         @{Name="State"; Expression={$_.StateFull}},`
         @{Name="Country"; Expression={$_.Country}},`
         @{Name="PostalCode"; Expression={$_.ZipCode}},`
         @{Name="EmailAddress"; Expression={$_.EmailAddress}},`
         @{Name="AccountPassword"; Expression={ (Convertto-SecureString -Force -AsPlainText "Password123")}},`
         @{Name="OfficePhone"; Expression={$_.TelephoneNumber}},`
         @{Name="Title"; Expression={$_.Occupation}},`
         @{Name="Enabled"; Expression={$true}},`
         @{Name="PasswordNeverExpires"; Expression={$true}}
         
$users | % {
    $subou = Get-ADOrganizationalUnit -Filter "name -eq ""$($_.Country)""" -SearchBase $ou.DistinguishedName        
    if($subou -eq $null) {
        New-ADOrganizationalUnit -Name $_.Country -Path $ou.DistinguishedName
        $subou = Get-ADOrganizationalUnit -Filter "name -eq ""$($_.Country)""" -SearchBase $ou.DistinguishedName        
    }
    Write-Host "Importing $($_.UserPrincipalName)..."
    $_ | Select @{Name="Path"; Expression={$subou.DistinguishedName}},* | New-ADUser  
}
