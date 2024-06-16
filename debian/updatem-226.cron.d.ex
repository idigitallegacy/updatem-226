#
# Regular cron jobs for the updatem-226 package
#
0 4	* * *	root	[ -x /usr/bin/updatem-226_maintenance ] && /usr/bin/updatem-226_maintenance
