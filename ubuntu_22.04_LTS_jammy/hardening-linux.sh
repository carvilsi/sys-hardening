#!/bin/bash
#
# Execute this script as sudo
# Note that this some steps requires human actions

# install lynins
# https://github.com/CISOfy/lynis.git

# TODO: Check if we have the correct system in this case Ubuntu 22.04 Jammy

# CONFIGURATION SECTION

SSH_PORT=22122
SSH_FOLDER=/etc/ssh/
SSH_CONFIG_FILE=sshd_config
MODPROBE_CONFIG_FILE=/etc/modprobe.d/blacklist.conf
LOGING_CONFIG_FILE=/etc/login.defs
ISSUE_FILE=/etc/issue
ISSUE_FILE_NET=/etc/issue.net
MODPROBE_PROTOCOL_CONF=/etc/modprobe.d/CIS.conf
LIMITS_CONF=/etc/security/limits.conf
SYSCTL_CONF=/etc/sysctl.conf
USB_STORAGE_CONF=/etc/modprobe.d/usb_storage.conf
GRUB_CONFIG_FILE=/etc/grub.d/10_linux

# TODO securing grub: https://linuxconfig.org/set-boot-password-with-grub

# Disabling all ports but ssh on custom port
# XXX uncomment
#ufw allow $SSH_PORT/tcp
#ufw enable

# sshd configuration
# XXX uncomment
#mv ${SSH_FOLDER}${SSH_CONFIG_FILE} ${SSH_FOLDER}${SSH_CONFIG_FILE}_back
#cp ${SSH_CONFIG_FILE}_hardened ${SSH_FOLDER}${SSH_CONFIG_FILE}
#echo "Port $SSH_PORT" >> ${SSH_FOLDER}${SSH_CONFIG_FILE}
#echo "sshd service listen port changed to ${SSH_PORT}"
#echo "use port option to connect since now: ssh -p ${SSH_PORT} $(whoami)@$(hostname -I)"
#read -p "press ENTER key to continue..." smthng
# wall "New ssh port ${SSH_PORT}"
#systemctl restart sshd

# file permissions
# XXX uncomment
#chmod 400 /boot/grub/grub.cfg
#chmod 700 /etc/cron.monthly/
#chmod 700 /etc/cron.daily/
#chmod 700 /etc/cron.d
#chmod 700 /etc/cron.hourly/
#chmod 700 /etc/cron.weekly/
#chmod 600 /etc/ssh/sshd_config
#chmod 600 /etc/crontab

# Disable useless protocols
# XXX uncomment this
#echo "install dccp /bin/true"     >> $MODPROBE_PROTOCOL_CONF
#echo "install sctp /bin/true"     >> $MODPROBE_PROTOCOL_CONF
#echo "install rds  /bin/true"     >> $MODPROBE_PROTOCOL_CONF
#echo "install tipc /bin/true"     >> $MODPROBE_PROTOCOL_CONF
#echo "install freevxfs /bin/true" >> $MODPROBE_PROTOCOL_CONF
#echo "install hfs /bin/true"      >> $MODPROBE_PROTOCOL_CONF
#echo "install cramfs /bin/true"   >> $MODPROBE_PROTOCOL_CONF
#echo "install jffs2 /bin/true"    >> $MODPROBE_PROTOCOL_CONF
#echo "install hfsplus /bin/true"  >> $MODPROBE_PROTOCOL_CONF
#echo "install udf /bin/true"      >> $MODPROBE_PROTOCOL_CONF
#
#
## core dumps
# XXX uncomment this
#echo "* hard core 0" >> $LIMITS_CONF
#echo "* soft core 0" >> $LIMITS_CONF
#
#echo "fs.suid_dumpable=0" 	       >> $SYSCTL_CONF
#echo "kernel.core_pattern=|/bin/false" >> $SYSCTL_CONF
#sysctl -p $SYSCTL_CONF

#Message disclaimer
# XXX uncomment
#printf "WARNING : Unauthorized access to this system is forbidden and will being " >  $ISSUE_FILE
#printf "prosecuted by law. By accessing this system, you agree that your actions " >> $ISSUE_FILE
#printf "may be monitored if unauthorized usage is suspected.\n" >> $ISSUE_FILE
#cat $ISSUE_FILE > $ISSUE_FILE_NET
#
#exit 0

#Change UMASK
# XXX uncomment this
#if grep --quiet "UMASK.*022" /etc/login.defs; then
#	sed -i 's/022/027/g' /etc/login.defs
#fi
#
#if ! grep --quiet "umask 027" /etc/profile; then
#	echo "umask 027" >> /etc/profile
#fi
#
#if ! grep --quiet "umask 027" /etc/bash.bashrc; then
#	echo "umask 027" >> /etc/bash.bashrc
#fi
#
#exit 0 

#Hardening compilers
# XXX uncomment this
#for _compiler in gcc cc clang g++ gcc; do
#	if [ -f /usr/bin/$_compiler ]; then
#		apt purge -y $_compiler
#	fi
#done

#Uninstall tools
# XXX uncomment this
#if [ -f /usr/bin/nc ]; then 
#	apt purge -y netcat-openbsd
#fi
#
#for _tool in wget nmap telnet curl; do
#	if [ -f /usr/bin/$_tool ]; then
#		apt purge -y $_tool
#	fi
#done

#sudo apt autoremove -y

#Disable media
# XXX uncomment this
#chmod 000 /media

#Disable USB Storge
# XXX uncomment this
#echo -e "install usb-storage /bin/true" > $USB_STORAGE_CONF
#
#for _i in /sys/bus/usb/devices/usb*/authorized; do 
#	echo 0 > $_i;
#done
#
#for _i in /sys/bus/usb/devices/usb*/authorized_default; do 
#	echo 0 > $_i;
#done


#Set disable IPv6
# XXX uncomment this
#cat /etc/*rele* | grep Ubuntu | grep 22.04 && sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/g' /etc/default/grub

#Set grub password
# XXX uncomment this
#if ! grep --quiet "unrestricted" /etc/grub.d/*; then 
#	sed -i 's/CLASS="--class gnu-linux --class gnu --class os"/CLASS="--class gnu-linux --class gnu --class os --unrestricted"/g' $GRUB_CONFIG_FILE
#fi
#
#echo "Going to configure grub password"
#read -p "Enter grub user name: " GRUB_USR_NAME
#echo "Going to set the hashed grub password"
#echo "You'll need to copy paste later"
#
#grub-mkpasswd-pbkdf2
#
#read -p "Enter grub hash password, copy and paste: " GRUB_PASSWORD
#
#echo 'cat <<EOF' >> $GRUB_CONFIG_FILE
#echo "set superusers=\""${GRUB_USR_NAME}"\"" >> $GRUB_CONFIG_FILE
#echo "password_pbkdf2 ${GRUB_USR_NAME} ${GRUB_PASSWORD}" >> $GRUB_CONFIG_FILE
#echo 'EOF' >> $GRUB_CONFIG_FILE
#
#update-grub

# deal with passwords policy 
# XXX uncomment this
#echo "SHA_CRYPT_MIN_ROUNDS 10000" >> $LOGING_CONFIG_FILE 
#echo "SHA_CRYPT_MAX_ROUNDS 15000" >> $LOGING_CONFIG_FILE

# TODO: This is not working as expected
#apt install -y libpam-pwquality
#sed -i 's/PASS_MAX_DAYS/#PASS_MAX_DAYS/g' /etc/login.defs 
#sed -i 's/PASS_MIN_DAYS/#PASS_MIN_DAYS/g' /etc/login.defs 
#printf "PASS_MAX_DAYS 90 \nPASS_MIN_DAYS 1" >> /etc/login.defs
#
#cp -f ./common-auth /etc/pam.d/common-auth
#chown root:root /etc/pam.d/common-auth
#chmod 644 /etc/pam.d/common-auth
#
#cp -f ./common-password /etc/pam.d/common-password
#chown root:root /etc/pam.d/common-password
#chmod 644 /etc/pam.d/common-password
#
#exit 0

# TODO: the whole section, mainly the configuration of the tools
# install and setting tools
apt install -y rkhunter aide auditd debsums acct ntp sysstat
aideinit
rkhunter -c
#cp /etc/pam.d/common-password /root/

# check https://www.cyberciti.biz/faq/securing-passwords-libpam-cracklib-on-debian-ubuntu-linux/
# sudo vi /etc/pam.d/common-password
# retry=3 minlen=16 difok=3 ucredit=-1 lcredit=-2 dcredit=-2 ocredit=-2

# sysstat config
# vim /etc/default/sysstat
echo "ENABLED=""true"""
#   ENABLED="true"
systemctl enable sysstat
systemctl start sysstat

# process accounting config
touch /var/log/pacct
accton /var/log/pacct

# AUDIT 
# TODO: check https://wiki.archlinux.org/title/Audit_framework
# this is not working CHECK
-w /etc/passwd -p rwxa
-w /etc/security -p rwxa
-a always,exit -S chmod
 auditctl -l >> /etc/audit/rules.d/additional.rules 
 

