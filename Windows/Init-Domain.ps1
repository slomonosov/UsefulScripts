$ad_name='isaev.local' # Name of your domain
$ad_mode=7 # Mode of domain and forest (7 = Server 2016)
$netbios='ISAEV' # NetBios name of domain ($netbios\user)
$pass=Read-Host -AsSecureString Enter SafeMode Admin Pass # Pass for recovery mode
install-windowsfeature AD-Domain-Services
Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainMode $ad_mode -DomainName $ad_name -DomainNetbiosName $netbios -ForestMode $ad_mode -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoRebootOnCompletion:$false -SysvolPath 'C:\Windows\SYSVOL' -Force:$true -SafeModeAdministratorPassword $pass