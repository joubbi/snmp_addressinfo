#!/bin/sh
###############################################################################
#                                                                             #
# A script for getting IP addresses from different Cisco devices with SNMP    #
# Written by farid@joubbi.se 2014-05-19                                       #
#                                                                             #
# USAGE:                                                                      #
# Add as a check in Op5/Nagios                                                #
# The check will always return OK.                                            #
#                                                                             #
###############################################################################

#set -x
#set -v

if [ $# == 3 ]; then
  SNMPOPT="-v 3 -a SHA -A $2 -l authPriv -u op5 -x AES -X $3 $1 -Ov -t 0.5 -Lo"
fi

if [ $# == 2 ]; then
  SNMPOPT="-v 2c -c $2 $1 -Ov -t 0.5 -Lo"
fi

if [ $# -lt 2 ]; then
  echo "Not enough arguments!"
  echo "Quitting!"
  exit 1
fi

ip=`/usr/bin/snmpwalk $SNMPOPT ".1.3.6.1.2.1.4.20.1.1" | /bin/sed -e 's/\IpAddress: //g' | tr '\n' ' '`
mask=`/usr/bin/snmpwalk $SNMPOPT ".1.3.6.1.2.1.4.20.1.3" | /bin/sed -e 's/\IpAddress: //g' | tr '\n' ' '`

awk -vm="$mask" -vip="$ip" 'BEGIN{n=split(m,a); split(ip,b); for (i=1; i<=n; i++) printf "%s %s<br>", b[i],a[i]}'
echo

exit 0
