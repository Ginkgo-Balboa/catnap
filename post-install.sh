#!/bin/bash

#################################
#                               #
# Script Post-Install Personnel #
# 2021-07-12 V1.1               #
#                               #
#################################

# Help
usage() 
{
	echo
	echo "---------------------------------------------------------------"
	echo "Post installation scripts for LABS."
	echo
	echo "Usage: $0 [-s] [--silent] | [-l] [--sourcelist]"
	echo "---------------------------------------------------------------"
	exit 2
}

# Le Message Of The Day, qui s'affichera à chaque connexion SSH
set_motd()
{
	if [ $VERBOSE = true ]; then
		echo
		echo "---------------------------------------------------------------"
		echo "[+] Creating a cool and welcoming message for SSH connections !"
		echo "[+]"
		echo "[+] ... "
		sleep 1
	fi

	rm -f /etc/motd
	cat /root/post-install/motd >> /etc/motd

	rm -f /etc/update-motd.d/10-uname
 
	echo "#!/bin/bash" >> /etc/update-motd.d/10-uname
	echo "" >> /etc/update-motd.d/10-uname
	echo "" >> /etc/update-motd.d/10-uname
	echo "neofetch" >> /etc/update-motd.d/10-uname
	
	chmod +x /etc/update-motd.d/10-uname

	if [ $VERBOSE = true ]; then
		echo "[+]"
		echo "[+] ʕっ•ᴥ•ʔっ Have fun !"
		echo "---------------------------------------------------------------"
		echo
		sleep 0.5
	fi
}

# Installation des paquets standards
set_packets()
{
	if [ $VERBOSE = true ]; then
		echo "---------------------------------------------------------------"
		echo "[+] Downloading some useful packets ..."
		echo "[+]"
		echo "[+] ... "
		echo
		sleep 1
	fi

	DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https ca-certificates ccze curl dnsutils gawk gcc git htop iptables-persistent less lsb-release lynx man neofetch net-tools nmap rsync screen tcpdump tzdata unzip vim wget zip

	if [ $VERBOSE = true ]; then
		echo
		echo "[+] ..."
		echo "[+]"
		echo "[+] ʕっ•ᴥ•ʔっ Packets installed !"
		echo "---------------------------------------------------------------"
		echo
		sleep 0.5
	fi
}

# Mise a jour du systeme
set_update ()
{
	if [ $VERBOSE = true ]; then
		echo "---------------------------------------------------------------"
		echo "[+] Updating and upgrading the system ..."
		echo "[+]"
		echo "[+] ... "
		echo
		sleep 1
	fi
	
	DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y full-upgrade

	if [ $VERBOSE = true ]; then
		echo
		echo "[+] ..."
		echo "[+]"
		echo "[+] ʕっ•ᴥ•ʔっ System updated !"
		echo "---------------------------------------------------------------"
		echo
		sleep 0.5
	fi
}

# Edition des préférences du vimrc
set_vimrc()
{
	if [ $VERBOSE = true ]; then
		echo "---------------------------------------------------------------"
		echo "[+] Editing the vimrc to be just like you like it ..."
		echo "[+]"
		echo "[+] ... "
		sleep 1
	fi
	
	mv /etc/vim/vimrc /etc/vim/vimrc.bak
	cat /root/post-install/vimr >> /etc/vim/vimrc

	if [ $VERBOSE = true ]; then
		echo "[+]"
		echo "[+] ʕっ•ᴥ•ʔっ vimrc edited !"
		echo "---------------------------------------------------------------"
		echo
		sleep 0.5
	fi
}

# Edition des préférences du vimrc
set_nanorc()
{
	if [ $VERBOSE = true ]; then
		echo "---------------------------------------------------------------"
		echo "[+] Editing the nanorc to be just like you like it ..."
		echo "[+]"
		echo "[+] ... "
		sleep 1
	fi
	
	mv /etc/nanorc /etc/nanorc.bak
	cat /root/post-install/nanorc >> /etc/nanorc

	if [ $VERBOSE = true ]; then
		echo "[+]"
		echo "[+] ʕっ•ᴥ•ʔっ nanorc edited !"
		echo "---------------------------------------------------------------"
		echo
		sleep 0.5
	fi
}

# Edition du .bashrc root
set_bashrc()
{
	if [ $VERBOSE = true ]; then
		echo "---------------------------------------------------------------"
		echo "[+] Editing the .bashrc to show us some colors ..."
		echo "[+]"
		echo "[+] ... "
		sleep 1
	fi

	sed -i "s+# export LS_OPTIONS='--color=auto'+export LS_OPTIONS='--color=auto'+g" /root/.bashrc
	sed -i 's+# eval "`dircolors`"+eval "`dircolors`"+g' /root/.bashrc
	sed -i "s+# alias ls='ls \$LS_OPTIONS'+alias ls='ls \$LS_OPTIONS'+g" /root/.bashrc
	sed -i "s+# alias ll='ls \$LS_OPTIONS -l'+alias ll='ls \$LS_OPTIONS -l'+g" /root/.bashrc
	sed -i "s+# alias l='ls \$LS_OPTIONS -lA'+alias l='ls \$LS_OPTIONS -lA'+g" /root/.bashrc

	if [ $VERBOSE = true ]; then
		echo "[+]"
		echo "[+] ʕっ•ᴥ•ʔっ .bashrc edited !"
		echo "---------------------------------------------------------------"
		echo
		sleep 0.5
	fi
}

# Ajout des dépôts "contrib" et "non-free" aux sources
set_sourcelist()
{
	if [ $VERBOSE = true ]; then
		echo "---------------------------------------------------------------"
		echo "[+] Adding non-free and contrib packages to the source list ..."
		echo "[+]"
		echo "[+] ... "
		echo
		sleep 1
	fi

	if [[ $SOURCE_LIST = true ]]; then
		apt-get-y install software-properties-common
		add-apt-repository contrib
		add-apt-repository non-free
	fi

	if [ $VERBOSE = true ]; then
		echo
		echo "[+] ..."
		echo "[+]"
		echo "[+] ʕっ•ᴥ•ʔっ Packages successfully added !"
		echo "---------------------------------------------------------------"
		echo
		sleep 0.5
	fi
}

# Ajout des clés SSH
set_ssh()
{
	if [ $VERBOSE = true ]; then
		echo "---------------------------------------------------------------"
		echo "[+] Any SSH keys ?"
		echo "[+]"
		echo "[+] ... "
		sleep 1
	fi

	while true; do
		read -p "$*[+] Would you like to add a SSH Pritvate Key for root login ? [y/n]: " yn
		case $yn in
			[Yy]*)
				read -p "[+] Paste your key here : " SSH_KEY ;
				mkdir -p /root/.ssh && echo "$SSH_KEY" >> /root/.ssh/authorized_keys ;
				sed -i 's+#PermitRootLogin prohibit-password+PermitRootLogin prohibit-password+g' /etc/ssh/sshd_config ;
				systemctl restart sshd ;
				if [ $VERBOSE = true ]; then
					echo "[+] ... "
					echo "[+]"
					echo "[+] ʕっ•ᴥ•ʔっ Key Added !"
					echo "---------------------------------------------------------------"
					echo
					sleep 0.5
				fi ;
				return 0 ;;
			[Nn]*)
				if [ $VERBOSE = true ]; then
					echo "[+] ... "
					echo "[+]"
					echo "[+] ʕっ•ᴥ•ʔっ No Key Added !"
					echo "---------------------------------------------------------------"
					echo
					sleep 0.5
				fi
				return 1 ;;
		esac
	done


}

set_yeehaa()
{
		if [ $VERBOSE = true ]; then
		echo "---------------------------------------------------------------"
		echo
		echo "            (-(-_-(-_(-_(-_-)_-)-_-)_-)_-)-)"
		echo
		echo "               The setup is now complete."
		echo
		echo "                     ╭(ʘ̆~◞౪◟~ʘ̆)╮ "
		echo
		echo
		echo "---------------------------------------------------------------"
		echo
		sleep 0.5
	fi
}
# Variables getops
SOURCE_LIST=false
VERBOSE=true

# -> Traitement des arguments
while getopts ":hvs:-:" option
do
	case $option in
		h ) usage ;;
		s ) VERBOSE=false ;;
		l ) SOURCE_LIST=true ;;
		- )
			LONG_OPTARG="${OPTARG#*=}"
			case $OPTARG in
				help ) usage ;;
				silent ) VERBOSE=false ;;
				sourcelist ) SOURCE_LIST=true ;;
				'' ) break ;;
				* )  echo "Illegal option --$OPTARG" >&2; exit 2 ;;
			esac
			;;
		: )
			echo "Missing arg for -$OPTARG option"
			exit 1
		;;
		\? )
			echo "$OPTARG: illegal option"
			exit 1
		;;
	esac
done
shift $((OPTIND-1))

set_motd
set_packets
set_update
set_vimrc
set_nanorc
set_bashrc
set_ssh
set_yeehaa
