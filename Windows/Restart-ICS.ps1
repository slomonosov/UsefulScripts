regsvr32 /s hnetcfg.dll
$m = New-Object -ComObject HNetCfg.HNetShare
$m.EnumEveryConnection |% { $m.NetConnectionProps.Invoke($_) }
$c = $m.EnumEveryConnection |? { $m.NetConnectionProps.Invoke($_).Name -eq "EXT" }
$config = $m.INetSharingConfigurationForINetConnection.Invoke($c)
Stop-Service -Name SharedAccess
$config.DisableSharing()
$config.EnableSharing(0)
Start-Service -Name SharedAccess