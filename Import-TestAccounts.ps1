Import-Module ActiveDirectory
$dn = (Get-ADDomain).DistinguishedName
$forest = (Get-ADDomain).Forest
 
$ou = Get-ADOrganizationalUnit -Filter 'name -eq "Test Users"'
if($ou -eq $null) {
    New-ADOrganizationalUnit -Name "Test Users" -Path $dn
    $ou = Get-ADOrganizationalUnit -Filter 'name -eq "Test Users"'
}

$users = $data | select  @{Name="Name";Expression={$_.Surname + ", " + $_.GivenName}},`
         @{Name="SamAccountName"; Expression={$_.GivenName + "." + $_.Surname}},`
         @{Name="UserPrincipalName"; Expression={$_.GivenName + "." + $_.Surname + "@" + $forest}},`
         @{Name="GivenName"; Expression={$_.GivenName}},`
         @{Name="Surname"; Expression={$_.Surname}},`
         @{Name="DisplayName"; Expression={$_.Surname + ", " + $_.GivenName}},`
         @{Name="City"; Expression={$_.City}},`
         @{Name="StreetAddress"; Expression={$_.StreetAddress}},`
         @{Name="State"; Expression={$_.StateFull}},`
         @{Name="Country"; Expression={$_.Country}},`
         @{Name="PostalCode"; Expression={$_.ZipCode}},`
         @{Name="EmailAddress"; Expression={$_.GivenName + "." + $_.Surname + "@" + $forest}},`
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
    $_ | Select @{Name="Path"; Expression={$subou.DistinguishedName}},* | New-ADUser  
}
