#! /bin/bash

function valid_ip(){
    local  ip=$1
    local  stat=1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

clear
echo -e "\e[96m©2021 Tekium. All rights reserved.\e[0m"
echo ''
echo -e '\e[96mInstaller for Docker-uAuditAnalyzer2 v1.0\e[0m'
echo ''
echo -e '\e[96mAuthor: Erick Rodríguez erickrr.tbd93@gmail.com\e[0m'
echo ''
echo -e '\e[96mLicense: GPLv3\e[0m'
echo ''
echo 'Do you want to install Docker-uAuditAnalyzer2 on your computer (Y/N)?'
read opc
if [ $opc = "Y" ] || [ $opc = "y" ]; then
	reg_exp_port='^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$'
	reg_exp_ip='^(?:(?:[1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}(?:[1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$|^localhost$'
	echo 'Do you want to install docker and docker-compose on your computer (Y/N)?'
	read opc_dc
	if [ $opc_dc = "Y" ] || [ $opc_dc = "y" ]; then
		dnf install curl -y
		dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo -y
		dnf config-manager --enable docker-ce-stable -y
		dnf check-update -y
		dnf install docker-ce docker-ce-cli containerd.io --nobest -y
		systemctl daemon-reload
		systemctl enable docker
		systemctl start docker
		curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
		chmod +x /usr/local/bin/docker-compose
		ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
		echo -e '\e[92mDocker and Docker-Compose have been installed on the computer...\e[0m'
	fi
	echo ''
	echo -e '\e[92mInstalling and configuring Docker-uAuditAnalyzer2...\e[0m'
	echo ''
	cp -r uauditanalyzer /etc
	while [ true ]; do
		echo 'Enter the IP address where uAuditAnalyzer will send the logs:'
		read ip
		if valid_ip $ip; then
			break
		else
			echo -e '\e[0;31mEnter a valid IP address\e[0m'
			echo ''
		fi
	done
	echo ''
	aux="s/127.0.0.1/$ip/g"
	sed -i $aux /etc/uauditanalyzer/uanlz_log2json/dispatchers.d/remotelog.ini
	while [ true ]; do
		echo 'Enter the port through which uanlz_log2json will receive the auditd logs:'
		read port_rl
		if [[ $port_rl =~ $reg_exp_port ]]; then
			break
		else
			echo -e '\e[0;31mEnter a valid port\e[0m'
			echo ''
		fi
	done
	echo ''
	aux2="s/port_rl/$port_rl/g"
	sed -i $aux2 /etc/uauditanalyzer/docker-compose.yml
        while [ true ]; do
                echo 'Enter the port through which uanlz_log2json will redirect logs:'
                read port_sl
                if [[ $port_sl =~ $reg_exp_port ]]; then
                        break
                else
                        echo -e '\e[0;31mEnter a valid port\e[0m'
			echo ''
                fi
        done
	echo '' 
        aux3="s/port_sl/$port_sl/g"
        sed -i $aux3 /etc/uauditanalyzer/docker-compose.yml
	while [ true ]; do
                echo 'Enter the listening port of uanlz_web:'
                read port_web
                if [[ $port_web =~ $reg_exp_port ]]; then
                        break
                else
                        echo -e '\e[0;31mEnter a valid port\e[0m'
			echo ''
                fi
        done
	echo ''
        aux4="s/port_web/$port_web/g"
        sed -i $aux4 /etc/uauditanalyzer/docker-compose.yml
	sleep 5
	echo ''
	echo -e '\e[92mCreating API Keys necessary for the operation of the application...\e[0m'
	apik_log2json=$(cat /dev/random | tr -dc '[:alpha:]' | head -c 25; echo)
	apik_alert=$(cat /dev/random | tr -dc '[:alpha:]' | head -c 25; echo)
	aux_2="s/REPLACEME_XABCXAPIX_ALERTS/$apik_alert/g"
	aux_3="s/REPLACEME_XABCXAPIX_LOG2JSON/$apik_log2json/g"
	sed -i  $aux_2 /etc/uauditanalyzer/uanlz_alert/config.ini
	sed -i  $aux_3 /etc/uauditanalyzer/uanlz_log2json/config.ini
	sed -i  $aux_2 /etc/uauditanalyzer/uanlz_web/config.ini
	sed -i  $aux_3 /etc/uauditanalyzer/uanlz_web/config.ini
	sleep 5
	echo ''
	echo -e '\e[92mInstallation and configuration of Docker-uAuditAnalyzer2 completed successfully...\e[0m'
else
	clear
	exit
fi

