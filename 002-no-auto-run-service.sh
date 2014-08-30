#!/bin/bash

readonly TMP_BEFORE_FILE="/var/tmp/chkconfig-list-before_$(date +"%Y.%m.%d_%H%M%S").tmp"
readonly TMP_AFTER_FILE="/var/tmp/chkconfig-list-after_$(date +"%Y.%m.%d_%H%M%S").tmp"
readonly ARRAY_SERVICE=( "NetworkManager"
                         "acpid"
                         "auditd"
                         "bluetooth"
                         "cpuspeed"
                         "cups"
                         "firstboot"
                         "httpd"
                         "ip6tables"
                         "iptables"
                         "irqbalance"
                         "kdump"
                         "mdmonitor"
                         "netconsole"
                         "netfs"
                         "nfs"
                         "nfslock"
                         "ntpd"
                         "ntpdate"
                         "postfix"
                         "psacct"
                         "quota_nld"
                         "rdisc"
                         "rngd"
                         "rpcbind"
                         "rpcgssd"
                         "saslauthd"
                         "smartd"
                         "spice-vdagentd"
                         "sysstat"
                         "wdaemon" )

# main
chkconfig --list >$TMP_BEFORE_FILE

echo ">> Disabled auto-run services."
for serviceName in ${ARRAY_SERVICE[@]}
do
  chkconfig --level 12345 $serviceName off
done

chkconfig --list >$TMP_AFTER_FILE

# verify
echo ""
echo ">> verify chkconfig"
echo "-----------------------------"
diff -u $TMP_BEFORE_FILE $TMP_AFTER_FILE | egrep "^\+" | grep -v "^\+++" | sort
echo "-----------------------------"
echo ""

exit 0
