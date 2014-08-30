#!/bin/bash

readonly TARGET_FILE='/etc/sudoers'

# main 
if [ ! -f "$TARGET_FILE" ]; then
  echo ">> [error] No such a file($TARGET_FILE)(exit=1)"
  exit 1
else
  grep "^#Defaults    requiretty" $TARGET_FILE >/dev/null
  if [ $? -eq 0 ]; then
    echo ">> Already changed setting(eabled sudo without password)"
  else
    echo ">> Change setting(eabled sudo without password)"
    sed -i".org" -e 's/Defaults    requiretty/#Defaults    requiretty/g' $TARGET_FILE
    {
      echo ""
      echo "vagrant ALL=(ALL) ALL"
      echo "%admin ALL=(ALL) NOPASSWD:ALL"
      echo 'Defaults env_keep += "SSH_AUTH_SOCK"'
    } >>$TARGET_FILE
  fi
fi

# verify
echo ""
echo ">> verify $TARGET_FILE"
grep "^#Defaults    requiretty" $TARGET_FILE >/dev/null
if [ $? -eq 0 ]; then 
  echo ">> [success] verified...[OK]."
else
  echo ">> [error] you need to correct manually($TARGET_FILE)."
fi

echo '-----------------------------'
grep "#Defaults    requiretty" $TARGET_FILE
tail -n 3 $TARGET_FILE
echo '-----------------------------'
echo ""

exit 0
