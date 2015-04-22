Import-Module ActiveDirectory
$dn = (Get-ADDomain).DistinguishedName
$forest = (Get-ADDomain).Forest
 
Set-ADDefaultDomainPasswordPolicy $forest -ComplexityEnabled $false -MaxPasswordAge "1000" -PasswordHistoryCount 0 -MinPasswordAge 0
 
$ou = Get-ADOrganizationalUnit -Filter 'name -eq "Test Users"'
if ($ou -eq $null) {
    New-ADOrganizationalUnit -Name "Test Users" -Path $dn
    $ou = Get-ADOrganizationalUnit -Filter 'name -eq "Test Users"'
}
