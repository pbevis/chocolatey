Install-windowsfeature AD-Domain-Services
Import-Module ADDSDeployment
Install-ADDSForest -ForestMode "Win2012R2" -DomainName "dev.com" -DomainMode "Win2012R2" -DomainNetbiosName "DEV" -InstallDns -NoRebootOnCompletion -Force
