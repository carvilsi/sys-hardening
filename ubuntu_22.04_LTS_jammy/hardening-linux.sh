#!/bin/bash
#
# Execute this script as sudo
# Note that this some steps requires human actions

# install lynins
# https://github.com/CISOfy/lynis.git

SSH_PORT=22122
SSH_CONFIG_FILE=/etc/ssh/sshd_config
MODPROBE_CONFIG_FILE=/etc/modprobe.d/blacklist.conf
LOGING_CONFIG_FILE=/etc/login.defs

# securing grub: https://linuxconfig.org/set-boot-password-with-grub

# Disabling all ports but ssh on custom port
ufw allow $SSH_PORT/tcp
ufw enable

# TODO: better to backup and create a new config file
# sshd configuration
mv $SSH_CONFIG_FILE ${SSH_CONFIG_FILE}_back
cp ${SSH_CONFIG_FILE}_hardened $SSH_CONFIG_FILE
echo "Port $SSH_PORT" >> $SSH_CONFIG_FILE
#echo "AllowTcpForwarding no" >> $SSH_CONFIG_FILE
#echo "ClientAliveCountMax 2" >> $SSH_CONFIG_FILE
#echo "LogLevel VERBOSE" >> $SSH_CONFIG_FILE
#echo "MaxAuthTries 3" >> $SSH_CONFIG_FILE
#echo "MaxSessions 2" >> $SSH_CONFIG_FILE
#echo "TCPKeepAlive no" >> $SSH_CONFIG_FILE
#echo "X11Forwarding no" >> $SSH_CONFIG_FILE
#echo "AllowAgentForwarding no" >> $SSH_CONFIG_FILE
#echo "Banner /etc/issue.net" >> $SSH_CONFIG_FILE
systemctl restart sshd

# install and setting tools
apt install -y rkhunter aide libpam-cracklib auditd debsums acct ntp sysstat
aideinit
rkhunter -c
cp /etc/pam.d/common-password /root/
# check https://www.cyberciti.biz/faq/securing-passwords-libpam-cracklib-on-debian-ubuntu-linux/
# sudo vi /etc/pam.d/common-password
# retry=3 minlen=16 difok=3 ucredit=-1 lcredit=-2 dcredit=-2 ocredit=-2

# sysstat config
# vim /etc/default/sysstat
#   ENABLED="true"
# systemctl enable sysstat
# systemctl start sysstat

# process accounting config
touch /var/log/pacct
accton /var/log/pacct

# USB things
echo "blacklist uas" >> $MODPROBE_CONFIG_FILE
echo "blacklist usb-storage" >> $MODPROBE_CONFIG_FILE

# passwords stuff
echo "SHA_CRYPT_MIN_ROUNDS 5000" >> $LOGING_CONFIG_FILE 
echo "SHA_CRYPT_MAX_ROUNDS 6000" >> $LOGING_CONFIG_FILE

# AUDIT 
# TODO: check https://wiki.archlinux.org/title/Audit_framework
#
#-w /etc/passwd -p rwxa
#-w /etc/security -p rwxa
#-a always,exit -S chmod
# auditctl -l >> /etc/audit/rules.d/additional.rules 

# Disable useless protocols
echo -e "install dccp /bin/true" >> /etc/modprobe.d/CIS.conf
echo -e "install sctp /bin/true" >> /etc/modprobe.d/CIS.conf
echo -e "install rds /bin/true" >> /etc/modprobe.d/CIS.conf
echo -e "install tipc /bin/true" >> /etc/modprobe.d/CIS.conf

# file permissions
chmod 400 /boot/grub/grub.cfg
chmod 700 /etc/cron.monthly/
chmod 700 /etc/cron.daily/
chmod 700 /etc/cron.d
chmod 700 /etc/cron.hourly/
chmod 700 /etc/cron.weekly/
chmod 600 /etc/ssh/sshd_config
chmod 600 /etc/crontab

# core dumps
echo "* hard core 0" >> /etc/security/limits.conf
echo "* soft core 0" >> /etc/security/limits.conf
echo "fs.suid_dumpable=0" >> /etc/sysctl.conf
echo "kernel.core_pattern=|/bin/false" >> /etc/sysctl.conf 
sysctl -p /etc/sysctl.conf

#Message disclaimer
printf “WARNING : Unauthorized access to this system is forbidden and will ben” > /etc/issue
printf “prosecuted by law. By accessing this system, you agree that your actionsn” >> /etc/issue
printf “may be monitored if unauthorized usage is suspected.n” >> /etc/issue
cat /etc/issue > /etc/issue.net

 

#Change UMASK
grep -q “UMASK.*022” /etc/login.defs
(($? == 0)) && sed -i ‘s/022/027/g’ /etc/login.defs
grep -q “umask 027” /etc/profile
(($? == 1)) && echo -e “umask 027” >> /etc/profile
grep -q “umask 027” /etc/bash.bashrc
(($? == 1)) && echo -e “umask 027” >> /etc/bash.bashrc

#Hardening compilers
for compiler in gcc cc clang g++ gcc;do
if [ -f /usr/bin/$compiler ];then
apt purge -y $compiler
fi
done

#Uninstall tools
if [ -f /usr/bin/nc ];then apt purge -y netcat-openbsd;fi
for tool in wget nmap telnet;do
if [ -f /usr/bin/$tool ];then
apt purge -y $tool
fi
done

 

#Set disable IPv6
cat /etc/*rele*|grep Ubuntu|grep 22.04 && sed -i ‘s/GRUB_CMDLINE_LINUX=””/GRUB_CMDLINE_LINUX=”ipv6.disable=1″/g’ /etc/default/grub


