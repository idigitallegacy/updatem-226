#!/bin/bash

datediff() {
	d1=$(date -d "$1" +%s)
	d2=$(date -d "$2" +%s)
	echo $(( (d1 - d2) / 86400 )) # days
}

timediff() {
	t1=$(date -d "$1" +%s)
	t2=$(date -d "$2" +%s)
	echo $(( (d1 - d2) / 60 )) # minutes
}


# Load update configuration:
source /etc/updatem-226/updatem-226.conf

# Load last-update data
source /etc/updatem-226/last-update.conf


time_start=$(date +%s)
time_now=$time_start
hour_now=$(date -d "@$time_now" +%H)

date_now=$(date '+%Y-%m-%d')
week_day_now=$(date '+%u')
date_difference=$(datediff $date_now $LAST_UPDATE_DATE)

if [[ $hour_now -ge 0 ]] && [[ $hour_now -le 3 ]] && $SCHEDULE_SHUTDOWN
then
	time_shutdown=$(( $time_now + 14400 ))
	time_scheduled=$(date -d "@$time_shutdown" "+%H:%M")
	shutdown -P $time_scheduled
fi

while [[ "$(hostname -I)" = "" ]]
do
	time_now=$(date +%s)
	echo -e "waiting for network..."
	if [[ $(datediff $time_now $time_start) -gt $NETWORK_TIMEOUT ]]
	then
		echo -e "unable to reach network. Shutting down"
		exit 1
	fi
done


if [[ $date_difference -lt $UPDATE_INTERVAL ]]
then
	exit 0
fi

if [[ $UPDATE_DAY -ne 0 ]] && [[ $UPDATE_DAY -ne $week_day_now ]]
then
	exit 0
fi

case $MODE in
	0)
		if $PREVENT_SHUTDOWN
		then
			systemd-inhibit --who="System update manager" --why="System update is in progress. Shutting down the PC may lead to device failure" bash /usr/bin/updatem-226/update-core.sh
		else
			bash /usr/bin/updatem-226/update-core.sh
		fi
		;;
	1)
		if $PREVENT_SHUTDOWN
		then
			systemd-inhibit --who="System update manager" --why="System update is in progress. Shutting down the PC may lead to device failure" bash /usr/bin/updatem-226/update-soft.sh
		else
			bash /usr/bin/updatem-226/update-soft.sh
		fi
		;;
	2)
		if $PREVENT_SHUTDOWN
		then
			systemd-inhibit --who="System update manager" --why="System update is in progress. Shutting down the PC may lead to device failure" bash /usr/bin/updatem-226/update-pull.sh
		else
			bash /usr/bin/updatem-226/update-pull.sh
		fi
		;;
esac

echo -e "# LAST UPDATE DATA.\n\n# DO\n# NOT\n# EDIT\n# THIS\n# FILE\n\nLAST_UPDATE_DATE="$date_now"\nLAST_STATE=\"null\"\nIS_COMPLETED=true" > /etc/updatem-226/last-update.conf
