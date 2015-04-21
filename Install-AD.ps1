Install-WindowsFeature –Name "AD-Domain-Services" -IncludeManagementTools
Import-Module ADDSDeployment
Install-ADDSForest -ForestMode "Win2012R2" -DomainName "dev.com" -DomainMode "Win2012R2" -DomainNetbiosName "DEV" -SafeModeAdministratorPassword (ConvertTo-SecureString "Password123" -AsPlainText -Force) -InstallDns -NoRebootOnCompletion -Force
