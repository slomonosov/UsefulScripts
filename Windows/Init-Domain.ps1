# Check if DNS installed. If not - install it.
$dnsinstalled=(Get-WindowsFeature -Name DNS | select InstallState) -match "Available"
if ($dnsinstalled) {
    Write-Host DNS is not installed, but Available. Install it!
    Install-WindowsFeature DNS
}
# $ad_name Name of your domain
$ad_name='example.com'
# $ad_mode Mode of domain and forest
# Windows Server 2003: 2
# Windows Server 2008: 3
# Windows Server 2008 R2: 4
# Windows Server 2012: 5
# Windows Server 2012 R2: 6
# Windows Server 2016: 7
$ad_mode=7
 # $netbios NetBios name of domain ($netbios\user)
$netbios='example'
 # $pass Pass for recovery mode.
$pass=Read-Host -AsSecureString Enter SafeMode Admin Pass
Install-WindowsFeature AD-Domain-Services
Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainMode $ad_mode -DomainName $ad_name -DomainNetbiosName $netbios -ForestMode $ad_mode -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoRebootOnCompletion:$false -SysvolPath 'C:\Windows\SYSVOL' -Force:$true -SafeModeAdministratorPassword $pass