#!/bin/bash
#VARS
DOMAIN='isaev.local' #название домена
DC_IP='10.1.3.4' #ip адрес контроллера домена
DC_NAME='dc.isaev.local' #полное имя контроллера домена
AD_USER='isaev' #учетная запись администратора домена
AD_PASS='MegaPass' #пароль администратора домена
SUDO_GROUP='linuxadm' #группа в AD, для которой разрешено подключение к серверам по ssh
#PRE
yum -y install realmd sssd oddjob oddjob-mkhomedir adcli samba-common samba-common-tools chrony
systemctl stop firewalld && systemctl disable firewalld
sed -i '/^server/d' /etc/chrony.conf
echo "server $DC_NAME iburst" >> /etc/chrony.conf
systemctl start chronyd && systemctl enable chronyd
#ADD
echo $AD_PASS | realm join -U $AD_USER $DOMAIN
#CONF
sed -i 's/use_fully_qualified_names = True/use_fully_qualified_names = False' /etc/sssd/sssd.conf
authconfig --enablemkhomedir --enablesssdauth --updateall
systemctl enable sssd.service && systemctl restart sssd
echo "%$SUDO_GROUP@$DOMAIN ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$SUDO_GROUP
chmod 0440 /etc/sudoers.d/$SUDO_GROUP