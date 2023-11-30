#Files permissions
chmod 400 /boot/grub/grub.cfg
chmod 700 /etc/cron.monthly
chmod 700 /etc/cron.daily
chmod 700 /etc/cron.d
chmod 700 /etc/cron.hourly
chmod 700 /etc/cron.weekly
chmod 600 /etc/ssh/sshd_config
chmod 600 /etc/crontab

#Disable media
chmod 000 /media

#Disable USB Storge
echo -e “install usb-storage /bin/true” > /etc/modprobe.d/usb_storage.conf
for i in /sys/bus/usb/devices/usb*/authorized;do echo 0 > $i;done
for i in /sys/bus/usb/devices/usb*/authorized_default;do echo 0 > $i;done

 

#Disable tipc freevxfs hfs cramfs jffs2 dccp sctp rds hfsplus udf protocols
echo -e “install tipc /bin/true” > /etc/modprobe.d/CIS.conf
echo -e “install freevxfs /bin/true” >> /etc/modprobe.d/CIS.conf
echo -e “install hfs /bin/true” >> /etc/modprobe.d/CIS.conf
echo -e “install cramfs /bin/true” >> /etc/modprobe.d/CIS.conf
echo -e “install jffs2 /bin/true” >> /etc/modprobe.d/CIS.conf
echo -e “install dccp /bin/true” >> /etc/modprobe.d/CIS.conf
echo -e “install sctp /bin/true” >> /etc/modprobe.d/CIS.conf
echo -e “install rds /bin/true” >> /etc/modprobe.d/CIS.conf
echo -e “install hfsplus /bin/true” >> /etc/modprobe.d/CIS.conf
echo -e “install udf /bin/true” >> /etc/modprobe.d/CIS.conf

 

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

#Set grub password
grep “unrestricted” -q /etc/grub.d/*(($? != 0)) && sed -i ‘s/CLASS=”–class gnu-linux –class gnu –class os/CLASS=”–class gnu-linux –class gnu –class os –unrestricted/g’ /etc/grub.d/10_linux

echo -e “cat << EOFnset superusers=”osboxes” npassword osboxes 1234 nEOFn” >> /etc/grub.d/10_linuxecho -e “cat << EOFnset superusers=”osboxes” npassword osboxes 1234 nEOFn” >> /etc/grub.d/10_linux
update-grub

#SSH Hardening
6 intentos
10 sesiones
bloqueo fordward
no permitido root login
etc…

sed -i ‘s/#AllowTcpForwarding yes/AllowTcpForwarding no/g’ /etc/ssh/sshd_config
sed -i ‘s/#ClientAliveCountMax 3/ClientAliveCountMax 2/g’ /etc/ssh/sshd_config
sed -i ‘s/#Compression delayed/Compression no/g’ /etc/ssh/sshd_config
sed -i ‘s/#LogLevel INFO/LogLevel VERBOSE/g’ /etc/ssh/sshd_config
sed -i ‘s/#MaxAuthTries 6/MaxAuthTries 3/g’ /etc/ssh/sshd_config
sed -i ‘s/#MaxSessions 10/MaxSessions 2/g’ /etc/ssh/sshd_config
sed -i ‘s/#TCPKeepAlive yes/TCPKeepAlive no/g’ /etc/ssh/sshd_config
sed -i ‘s/X11Forwarding yes/X11Forwarding no/g’ /etc/ssh/sshd_config
sed -i ‘s/#AllowAgentForwarding yes/AllowAgentForwarding no/g’ /etc/ssh/sshd_config
sed -i ‘s/#Banner none/Banner /etc/issue.net/g’ /etc/ssh/sshd_config
sed -i ‘s/#Port 22/Port 22122/g’ /etc/ssh/sshd_config
sed -i ‘s/#PermitRootLogin/PermitRootLogin no #/g’ /etc/ssh/sshd_config
sed -i ‘s/#Banner none/Banner/g’ /etc/issue
wall “Nuevo puerto ssh 22122”
systemctl restart sshd

 

Política de contraseñas.
Estas políticas aplican a los usuarios del sistema.

Longitud mínima 12.
Obligatorio una minúscula.
Obligatorio una mayúscula.
Obligatorio un digito
Obligatorio un carácter especial.
Recordatorio de 5 contraseñas.
Expiración contraseña de 90 días.

Esta política aplica a todos los usuarios.

Bloquear cuenta después de 3 intentos de acceso durante 15 minutos.
Los intentos fallidos de login son acumulativos, el numero de intentos solo se reinicia mediante un acceso legitimo.
Logout sesión a los 15 minutos.

#Configuracion politica de contraseñas y bloqueo de
Crear common-password

password requisite pam_pwquality.so retry=3 minlen=12 minclass=4 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1
password [success=1 default=ignore] pam_unix.so obscure yescrypt remember=15
password requisite pam_deny.so
password required pam_permit.so

Crear common-auth
auth required pam_faillock.so preauth audit silent deny=3 unlock_time=900
auth [success=2 default=ignore] pam_unix.so nullok
auth [success=1 default=ignore] pam_sss.so nullok

auth [default=die] pam_faillock.so authfail audit deny=3 unlock_time=900
auth sufficient pam_faillock.so authsucc audit deny=3 unlock_time=900
auth requisite pam_deny.so
auth required pam_permit.so
auth optional pam_cap.so

apt install -y libpam-pwquality
sed -i ‘s/PASS_MAX_DAYS/#PASS_MAX_DAYS/g’ /etc/login.defs && sed -i ‘s/PASS_MIN_DAYS/#PASS_MIN_DAYS/g’ /etc/login.defs && printf “n##CIBERnPASS_MAX_DAYS 90nPASS_MIN_DAYS 1nSHA_CRYPT_MIN_ROUNDS 10000n” >> /etc/login.defs
echo ‘TMOUT=900’ >> /etc/profile
cp -f /home/osboxes/hardening/common-auth /etc/pam.d/common-auth && chown root:root /etc/pam.d/common-auth && chmod 644 /etc/pam.d/common-auth
cp -f /home/osboxes/hardening/common-password /etc/pam.d/common-password && chown root:root /etc/pam.d/common-password && chmod 644 /etc/pam.d/common-password