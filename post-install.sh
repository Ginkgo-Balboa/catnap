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
	echo "---------------------------------------------------------------"
	echo "Script de post-installation pour serveurs catnap."
	echo
	echo "Usage: $0 [-v] [--sourcelist]"
	exit 2
}

# Le Message Of The Day, qui s'affichera à chaque connexion SSH
set_motd()
{
	if [ $VERBOSE = true ]; then
		echo "---------------------------------------------------------------"
		echo "[+] Creating a cool and welcoming message for SSH connections !"
		echo "[+] ... "
		echo
		sleep 1
	fi

	rm -f /etc/motd
	cat motd >> /etc/motd

	rm -f /etc/update-motd.d/10-uname
 
	echo "#!/bin/bash" >> /etc/update-motd.d/10-uname
	echo "" >> /etc/update-motd.d/10-uname
	echo "" >> /etc/update-motd.d/10-uname
	echo "neofetch" >> /etc/update-motd.d/10-uname
	
	chmod +x /etc/update-motd.d/10-uname

	if [ $VERBOSE = true ]; then
		echo
		echo "[+] ..."
		echo "[+] Done !"
		echo "---------------------------------------------------------------"
		echo
		sleep 0.5
	fi
}

# -> Installation des paquets standards
set_packets()
{
	if [ $VERBOSE = true ]; then
		echo "---------------------------------------------------------------"
		echo "[+] Downloading some useful packets ..."
		echo "[+] ... "
		echo
		sleep 1
	fi

	DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https ca-certificates ccze curl dnsutils gcc git htop iptables-persistent less lsb-release lynx man neofetch net-tools nmap rsync screen tzdata unzip vim wget zip

	if [ $VERBOSE = true ]; then
		echo
		echo "[+] ..."
		echo "[+] Done !"
		echo "---------------------------------------------------------------"
		echo
		sleep 0.5
	fi
}

# -> Mise a jour du systeme
set_update ()
{
	if [ $VERBOSE = true ]; then
		echo "---------------------------------------------------------------"
		echo "[+] Updating and upgrading the system ..."
		echo "[+] ... "
		echo
		sleep 1

	DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y full-upgrade

	if [ $VERBOSE = true ]; then
		echo
		echo "[+] ..."
		echo "[+] Done !"
		echo "---------------------------------------------------------------"
		echo
		sleep 0.5
	fi
}

# -> Edition des préférences du vimrc
set_vimrc()
{
	if [ $VERBOSE = true ]; then
		echo "---------------------------------------------------------------"
		echo "[+] Editing the .vimrc to be just like you like it ..."
		echo "[+] ... "
		echo
		sleep 1
	fi


	if [ $VERBOSE = true ]; then
		echo
		echo "[+] ..."
		echo "[+] Done !"
		echo "---------------------------------------------------------------"
		echo
		sleep 0.5
	fi
}

# -> Edition du .bashrc pour root
set_bashrc()
{
	if [ $VERBOSE = true ]; then
		echo "---------------------------------------------------------------"
		echo "[+] Editing the .bashrc to show us some colors ..."
		echo "[+] ... "
		echo
		sleep 1
	fi

	mv /etc/vim/vimrc /etc/vim/vimrc.bak
	cat vimrc >> /etc/vim/vimrc

	if [ $VERBOSE = true ]; then
		echo
		echo "[+] ..."
		echo "[+] Done !"
		echo "---------------------------------------------------------------"
		echo
		sleep 0.5
	fi
}

# -> Ajout des dépôts "contrib" et "non-free" aux sources
set_sourcelist()
{
	if [ $VERBOSE = true ]; then
		echo "---------------------------------------------------------------"
		echo "[+] Adding non-free and contrib packages to the source list ..."
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
		echo "[+] Done !"
		echo "---------------------------------------------------------------"
		echo
		sleep 0.5
	fi
}

# -> Variables getops
SOURCE_LIST=false
VERBOSE=true

# -> Test sur les arguments
#	if [ $# = 0 ]; then usage ; fi

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
				* )  echo "Illegal option --$OPTARG" > &2; exit 2 ;;
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
set_bashrc
