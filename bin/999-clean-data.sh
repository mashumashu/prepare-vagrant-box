#!/bin/bash

# main

rm -ir /var/tmp/*

rm -rf /var/lib/dhcp/*

yum clean all

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

sudo -u vagrant cat /dev/null >~/.bash_history
cat /dev/null >~/.bash_history

exit 0
