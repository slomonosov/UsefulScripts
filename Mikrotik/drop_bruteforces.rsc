/ip firewall filter add chain=input action=drop comment="Bruteforce login prevention(Winbox: droop Winbox brute forcers)" dst-port=8291 protocol=tcp src-address-list=winbox_blacklist
/ip firewall filter add chain=input action=add-src-to-address-list address-list=winbox_blacklist address-list-timeout=15d comment="Bruteforce login prevention(Winbox: stage3 to winbox_blacklist)" connection-state=new dst-port=8291 protocol=tcp src-address-list=winbox_stage_3
/ip firewall filter add chain=input action=add-src-to-address-list address-list=winbox_stage3 address-list-timeout=1m  comment="Bruteforce login prevention(Winbox: stage2 to stage3)" connection-state=new dst-port=8291 protocol=tcp src-address-list=winbox_stage_2
/ip firewall filter add chain=input action=add-src-to-address-list address-list=winbox_stage2 address-list-timeout=6h comment="Bruteforce login prevention(Winbox: stage1 to stage2)" connection-state=new dst-port=8291 protocol=tcp src-address-list=winbox_stage_1
/ip firewall filter add chain=input action=add-src-to-address-list address-list=winbox_stage1 address-list-timeout=12h comment="Bruteforce login prevention(Winbox: stage1)" connection-state=new dst-port=8291 protocol=tcp
/ip firewall filter add chain=input action=drop comment="Bruteforce login prevention(ssh: droop ssh brute forcers)" dst-port=22 protocol=tcp src-address-list=ssh_blacklist
/ip firewall filter add chain=input action=add-src-to-address-list address-list=ssh_blacklist address-list-timeout=15d comment="Bruteforce login prevention(ssh: stage3 to ssh_blacklist)" connection-state=new dst-port=22 protocol=tcp src-address-list=ssh_stage_3
/ip firewall filter add chain=input action=add-src-to-address-list address-list=ssh_stage3 address-list-timeout=1m  comment="Bruteforce login prevention(ssh: stage2 to stage3)" connection-state=new dst-port=22 protocol=tcp src-address-list=ssh_stage_2
/ip firewall filter add chain=input action=add-src-to-address-list address-list=ssh_stage2 address-list-timeout=6h comment="Bruteforce login prevention(ssh: stage1 to stage2)" connection-state=new dst-port=22 protocol=tcp src-address-list=ssh_stage_1
/ip firewall filter add chain=input action=add-src-to-address-list address-list=ssh_stage1 address-list-timeout=12h comment="Bruteforce login prevention(ssh: stage1)" connection-state=new dst-port=22 protocol=tcp