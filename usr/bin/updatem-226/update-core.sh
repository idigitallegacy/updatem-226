#!/bin/bash

# Load last-update data
source /etc/updatem-226/last-update.conf

date_now=$(date '+%Y-%m-%d')

if $IS_COMPLETED
then
	echo -e "=================== UPDATE STARTED ===================" > /var/log/updatem-226/logfile
	echo -e "==================== $date_now ===================" >> /var/log/updatem-226/logfile
	IS_COMPLETED=false
	echo -e "# LAST UPDATE DATA.\n\n# DO\n# NOT\n# EDIT\n# THIS\n# FILE\n\nLAST_UPDATE_DATE="$date_now"\nLAST_STATE=\"null\"\nIS_COMPLETED=false" > /etc/updatem-226/last-update.conf
fi

if [[ $LAST_STATE == "null" ]]
then
	echo -e "=================== apt update started ===================" >> /var/log/updatem-226/logfile
	apt update >> /var/log/updatem/logfile
	LAST_STATE="pull"
	echo -e "# LAST UPDATE DATA.\n\n# DO\n# NOT\n# EDIT\n# THIS\n# FILE\n\nLAST_UPDATE_DATE="$date_now"\nLAST_STATE=\"pull\"\nIS_COMPLETED=false" > /etc/updatem-226/last-update.conf
	echo -e "=================== apt update finished ===================" >> /var/log/updatem-226/logfile
fi

if [[ $LAST_STATE == "pull" ]]
then
	echo -e "=================== apt dist-upgrade started ===================" >> /var/log/updatem-226/logfile
	apt dist-upgrade -y -o Dpkg::Options:=--force-confnew >> /var/log/updatem-226/logfile
	LAST_STATE="update"
	echo -e "# LAST UPDATE DATA.\n\n# DO\n# NOT\n# EDIT\n# THIS\n# FILE\n\nLAST_UPDATE_DATE="$date_now"\nLAST_STATE=\"update\"\nIS_COMPLETED=false" > /etc/updatem-226/last-update.conf
	echo -e "=================== apt dist-upgrade finished ===================" >> /var/log/updatem-226/logfile
fi

date_now=$(date '+%Y-%m-%d')
echo -e "=================== update finished ===================" >> /var/log/updatem-226/logfile
echo -e "=================== $date_now ===================" >> /var/log/updatem-226/logfile
echo -e "# LAST UPDATE DATA.\n\n# DO\n# NOT\n# EDIT\n# THIS\n# FILE\n\nLAST_UPDATE_DATE="$date_now"\nLAST_STATE=\"null\"\nIS_COMPLETED=true" > /etc/updatem-226/last-update.conf
