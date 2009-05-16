#
# Regular cron jobs for the bliss package
#
0 4	* * *	root	[ -x /usr/bin/bliss_maintenance ] && /usr/bin/bliss_maintenance
