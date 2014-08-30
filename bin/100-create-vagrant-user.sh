#!/bin/bash

readonly PASS_FILE="/tmp/pass.tmp"

# main
id vagrant >/dev/null 2>&1
if [ $? -eq 1 ]; then
  groupadd -g 5000 vagrant
  groupadd -g 5001 admin
  useradd -g vagrant -G admin -u 5000 vagrant

  echo "vagrant:vagrant" >$PASS_FILE
  chpasswd <$PASS_FILE
  rm -f $PASS_FILE
fi

# verify
echo ""
echo ">> verify vagrant-user."
id vagrant
if [ $? -eq 0 ]; then
  echo ">> [success] verified...[OK]."
else
  echo ">> [error] you need to correct manually(vagrant-user)."
fi
echo ""

exit 0
