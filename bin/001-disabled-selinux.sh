#!/bin/bash

readonly TARGET_FILE="/etc/selinux/config"

# main 
if [ ! -f "$TARGET_FILE" ]; then
  echo ">> Create a new file($TARGET_FILE), because no such a file($TARGET_FILE)."
  {
    echo "SELINUX=disabled"
    echo "SELINUXTYPE=targeted"
  } >>$TARGET_FILE
else
  grep "^SELINUX=disabled" $TARGET_FILE >/dev/null
  if [ $? -eq 0 ]; then
    echo ">> No change. because already SELINUX=disabled."
    exit 0
  else
    echo ">> Change setting(SELINUX=.* -> SELINUX=disabled)."
    sed -i -e 's/^SELINUX=.*/SELINUX=disabled/g' $TARGET_FILE
  fi
fi

# verify
echo ""
echo ">> verify $TARGET_FILE"
grep "^SELINUX=disabled" $TARGET_FILE >/dev/null
if [ $? -eq 0 ]; then
  echo ">> [success] verified...[OK]."
else
  echo ">> [error] you need to correct manually($TARGET_FILE)."
  echo "-----------------------------"
  cat $TARGET_FILE
  echo "-----------------------------"
fi

exit 0
