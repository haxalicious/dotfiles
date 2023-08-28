#!/bin/bash
read user
param[1]="PermitRootLogin"
param[2]="PasswordAuthentication"
for PARAM in ${param[@]} # Disable password and root login for SSH
do
	/usr/bin/sed -i '/^'"${PARAM}"'/d' /etc/ssh/sshd_config
	/usr/bin/echo "${PARAM} no" >> /etc/ssh/sshd_config
done
/usr/bin/systemctl restart sshd
if [ -f /usr/bin/apt-get ]; then # Configure apt and install zsh on Debian systems
	/usr/bin/apt-get update
	/usr/bin/apt-get install apt-transport-https -y
	/usr/bin/sed -i 's/http:/https:/g' /etc/apt/sources.list
	/usr/bin/sed -i 's/main$/main contrib non-free/g' /etc/apt/sources.list
	/usr/bin/apt-get update
	/usr/bin/apt-get install unattended-upgrades -y
	echo unattended-upgrades unattended-upgrades/enable_auto_updates boolean true | debconf-set-selections
	dpkg-reconfigure -f noninteractive unattended-upgrades
	/usr/bin/apt-get install zsh -y
fi
[ -f /usr/bin/pacman ] && /usr/bin/pacman -S zsh --noconfirm # Install zsh on Arch systems
/usr/bin/chsh -s /bin/zsh $user
eval rm ~$user/.bash_history
eval rm ~$user/setup.sh
