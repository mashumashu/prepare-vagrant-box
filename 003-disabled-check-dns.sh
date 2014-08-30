#!/bin/bash

readonly TARGET_FILE="/etc/ssh/sshd_config"

# main 
if [ ! -f "$TARGET_FILE" ]; then
  echo ">> [error] No such a file($TARGET_FILE), this script stop(exit=1)."
  exit 1
else
  grep "^UseDNS no" $TARGET_FILE >/dev/null
  if [ $? -eq 0 ]; then
    echo ">> No change. because already UseDNS no."
    exit 0
  else
    echo ">> Change setting(disabled to check DNS when you ssh connect)"
    sed -i".org" -e 's/#UseDNS yes/UseDNS no/g' $TARGET_FILE
  fi
fi

# verify
echo ""
echo ">> verify $TARGET_FILE"

grep "^UseDNS no" $TARGET_FILE >/dev/null
if [ $? -eq 0 ]; then
  echo ">> [success] verified...[OK]."
else
  echo ">> [error] you need to correct manually($TARGET_FILE)."
fi
echo ""

exit 0
