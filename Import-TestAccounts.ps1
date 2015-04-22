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
$filePath = [System.IO.Path]::Combine($tempPath, "Users.csv")

$client = New-Object System.Net.WebClient
$client.DownloadFile("http://api.randomuser.me/?seed=fsp&results=500&format=csv", $filePath) 

$data = Import-Csv $filePath

$users = $data | select  @{Name="Name";Expression={$_.last + ", " + $_.first}},`
         @{Name="SamAccountName"; Expression={$_.username}},`
         @{Name="UserPrincipalName"; Expression={$_.username + "@" + $forest}},`
         @{Name="GivenName"; Expression={$_.first}},`
         @{Name="Surname"; Expression={$_.last}},`
         @{Name="DisplayName"; Expression={$_.last + ", " + $_.first}},`
         @{Name="City"; Expression={$_.city}},`
         @{Name="StreetAddress"; Expression={$_.street}},`
         @{Name="State"; Expression={$_.state}},`
         @{Name="PostalCode"; Expression={$_.zip}},`
         @{Name="EmailAddress"; Expression={$_.email}},`
         @{Name="AccountPassword"; Expression={ (Convertto-SecureString -Force -AsPlainText "Password123")}},`
         @{Name="OfficePhone"; Expression={$_.phone}},`
         @{Name="Enabled"; Expression={$true}},`
         @{Name="PasswordNeverExpires"; Expression={$true}}
         
$users | % {
    Write-Host "Importing $($_.UserPrincipalName)..."
    $_ | Select @{Name="Path"; Expression={$dn}},* | New-ADUser  
}
