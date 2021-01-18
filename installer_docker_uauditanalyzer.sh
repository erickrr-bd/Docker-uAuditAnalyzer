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
echo "©2021 Tekium. All rights reserved."
echo ''
echo 'Installer for Docker-uAuditAnalyzer2 v1.0'
echo ''
echo 'Author: Erick Rodríguez erickrr.tbd93@gmail.com'
echo ''
echo 'License: GPLv3'
echo ''
echo 'Do you want to install Docker-uAuditAnalyzer2 on your computer (Y/N)?'
read opc
if [ $opc = "Y" ] || [ $opc = "y" ]; then
	echo 'Installing and configuring Docker-uAuditAnalyzer2...'
	cp -r uauditanalyzer /etc
	aux_bool=true
	while [ aux_bool ]; do
		echo 'Enter the IP address where uAuditAnalyzer will send the logs:'
		read ip
		if valid_ip $ip; then
			break
		else
			echo 'Enter a valid IP address'
		fi
	done
	aux="s/127.0.0.1/$ip/g"
	sed -i $aux /etc/uauditanalyzer/uanlz_log2json/dispatchers.d/remotelog.ini
	sleep 5
	echo 'Creating API Keys necessary for the operation of the application...'
	apik_log2json=$(cat /dev/random | tr -dc '[:alpha:]' | head -c 25; echo)
	apik_alert=$(cat /dev/random | tr -dc '[:alpha:]' | head -c 25; echo)
	aux_2="s/REPLACEME_XABCXAPIX_ALERTS/$apik_alert/g"
	aux_3="s/REPLACEME_XABCXAPIX_LOG2JSON/$apik_log2json/g"
	sed -i  $aux_2 /etc/uauditanalyzer/uanlz_alert/config.ini
	sed -i  $aux_3 /etc/uauditanalyzer/uanlz_log2json/config.ini
	sed -i  $aux_2 /etc/uauditanalyzer/uanlz_web/config.ini
	sed -i  $aux_3 /etc/uauditanalyzer/uanlz_web/config.ini
	sleep 5
	echo 'Running Docker-uAuditAnalyzer2...'
	cd /etc/uauditanalyzer
else
	clear
	exit
fi

