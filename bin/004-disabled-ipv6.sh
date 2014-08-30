#!/bin/bash

readonly HOSTS_FILE="/etc/hosts"
readonly TARGET_FILE="/etc/sysctl.conf"
sysctl_flag=0

# main 
## Disable local name resolution IPv6
if [ ! -f "$HOSTS_FILE" ]; then
  echo ">> [error] No such a file($HOSTS_FILE), this script stop(exit=1)."
  exit 1
else
  sed -i -e 's/^::1/#::1/g' $HOSTS_FILE
fi


## Disable IPv6 in kernel parameters
if [ ! -f "$TARGET_FILE" ]; then
  echo ">> [error] No such a file($TARGET_FILE), this script stop(exit=1)."
  exit 1
else
  cp -p $TARGET_FILE{,.$(date +"%Y.%m.%d_%H%M%S")}
  sed -i -e 's/^net.bridge.bridge-nf-call-/#net.bridge.bridge-nf-call-/g' $TARGET_FILE
  sed -i -e 's/^net.ipv6.conf.all.disable_ipv6 = 0/net.ipv6.conf.all.disable_ipv6 = 1/g' $TARGET_FILE
  sed -i -e 's/^net.ipv6.conf.default.disable_ipv6 = 0/net.ipv6.conf.default.disable_ipv6 = 1/g' $TARGET_FILE
  
  grep "^net.ipv6.conf.all.disable_ipv6 = 1" $TARGET_FILE >/dev/null
  if [ $? -eq 0 ]; then
    echo ">> No change. because already net.ipv6.conf.all.disable_ipv6 = 1."
  else
    echo ">> Add setting(net.ipv6.conf.all.disable_ipv6 = 1)"
    echo "" >>$TARGET_FILE
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >>$TARGET_FILE
    sysctl_flag=$((sysctl_flag + 1))
  fi

  grep "^net.ipv6.conf.default.disable_ipv6 = 1" $TARGET_FILE >/dev/null
  if [ $? -eq 0 ]; then
    echo ">> No change. because already net.ipv6.conf.default.disable_ipv6 = 1."
  else
    echo ">> Add setting(net.ipv6.conf.default.disable_ipv6 = 1)"
    echo "net.ipv6.conf.default.disable_ipv6 = 1" >>$TARGET_FILE
    sysctl_flag=$((sysctl_flag + 1))
  fi
  if [ $sysctl_flag -ne 0 ]; then
    echo ">> sysctl -p..."
    sysctl -p
  fi
fi

# verify
echo ""
echo ">> verify $HOSTS_FILE"
grep "^#::1" $HOSTS_FILE >/dev/null
if [ $? -eq 0 ]; then
  echo ">> [success] verified...[OK]."
else
  echo ">> [error] you need to correct manually($HOSTS_FILE)."
fi

echo ""
echo ">> verify $TARGET_FILE"
grep "^net.ipv6.conf.all.disable_ipv6 = 1" $TARGET_FILE >/dev/null
if [ $? -eq 0 ]; then
  grep "^net.ipv6.conf.default.disable_ipv6 = 1" $TARGET_FILE >/dev/null
  if [ $? -eq 0 ]; then
    echo ">> [success] verified...[OK]."
  else
    echo ">> [error] you need to correct manually($TARGET_FILE)."
  fi
else
  echo ">> [error] you need to correct manually($TARGET_FILE)."
fi
echo ""

exit 0
