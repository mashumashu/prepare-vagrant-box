#!/bin/bash

readonly TARGET_FILE="/etc/sysconfig/clock"

# main 
if [ ! -f "$TARGET_FILE" ]; then
  echo ">> Create a new file($TARGET_FILE), because no such a file($TARGET_FILE)."
  {
    echo 'ZONE="Asia/Tokyo"'
    echo 'UTC="false"'
  } >>$TARGET_FILE
else
  grep '^UTC="false"' $TARGET_FILE >/dev/null
  if [ $? -eq 0 ]; then
    echo '>> No change. because already UTC="false".'
    exit 0
  fi
  grep "^UTC=" $TARGET_FILE >/dev/null 
  if [ $? -eq 0 ]; then
    echo '>> Change setting(UTC=.* -> UTC="false").'
    sed -i -e 's/UTC=.*/UTC="false"/g' $TARGET_FILE
  else
    echo 'UTC="false"' >>$TARGET_FILE
  fi
fi

# verify
echo ""
echo ">> verify $TARGET_FILE"
grep 'UTC="false"' $TARGET_FILE >/dev/null
if [ $? -eq 0 ]; then
  echo ">> [success] verified...[OK]."
else
  echo ">> [error] you need to correct manually($TARGET_FILE)."
  echo "-----------------------------"
  cat $TARGET_FILE
  echo "-----------------------------"
fi
echo ""

exit 0
