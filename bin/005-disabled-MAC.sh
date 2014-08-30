#!/bin/bash

readonly TARGET_70PERSISTENT_FILE="/etc/udev/rules.d/70-persistent-net.rules"
readonly ETH_FILENAME_ARRAY=( "ifcfg-eth0" )
readonly TARGET_65ETH_FILE="/etc/udev/rules.d/65-eth.rules"
readonly TARGET_DIR="/etc/sysconfig/network-scripts"

# main
## Disabled auto-registry MAC address by 70-persistent-net.rules
ls -l "$TARGET_70PERSISTENT_FILE" | grep "/dev/null"
if [ $? -eq 0 ]; then
  echo ">> No change. because alreadly $TARGET_70PERSISTENT_FILE -> /dev/null."
else
  echo ">> Disabled auto-registry MAC address by 70-persistent-net.rules."
  ln -s -f /dev/null "$TARGET_70PERSISTENT_FILE"
fi

## Fixed allocation of NIC and ethX
rm -f "$TARGET_65ETH_FILE"

declare -A ethX_id_hash
if [ ! -f "$TARGET_65ETH_FILE" ]; then
  echo ">> Create a new file($TARGET_65ETH_FILE), because no exist such a file($TARGET_65ETH_FILE)"
  for ethX in ${ETH_FILENAME_ARRAY[@]}
  do

    ethX=$(echo $ethX | awk -F"-" '{print $2}')
    ethX_id=$(ethtool -i $ethX | grep "^bus-info" | awk -F" " '{print $2}')
    echo 'ACTION=="add", KERNEL=="eth*", ID=="'"$ethX_id"'", DRIVERS=="?*", ATTR{type}=="1", NAME="'"$ethX"'", OPTIONS="last_rule"' >>$TARGET_65ETH_FILE
    ethX_id_hash["$ethX"]=$ethX_id
  done
fi

## Disabled UUID and MAC address on ifcfg-ethX
for ethX in ${ETH_FILENAME_ARRAY[@]}
do
  ethX_file="$TARGET_DIR/$ethX"

  grep "^UUID=" $ethX_file >/dev/null
  if [ $? -eq 0 ]; then
    sed -i -e 's/UUID=/#UUID=/g' $ethX_file
  fi
  
  grep "^NM_CONTROLLED=yes" $ethX_file >/dev/null
  if [ $? -eq 0 ]; then
    sed -i -e 's/NM_CONTROLLED=yes/NM_CONTROLLED=no/g' $ethX_file
  fi

  grep "^HWADDR=" $ethX_file >/dev/null
  if [ $? -eq 0 ]; then
    sed -i -e 's/HWADDR=/#HWADDR=/g' $ethX_file
  fi
done

# verify
echo ""
echo ">> verify $TARGET_70PERSISTENT_FILE"
ls -l "$TARGET_70PERSISTENT_FILE" | grep "/dev/null"
if [ $? -eq 0 ]; then
  echo ">> [success] verified...[OK]."
else
  echo ">> [error] you need to correct manually($TARGET_70PERSISTENT_FILE)."
fi

chk_flag=0
echo ""
echo ">> verify $TARGET_65ETH_FILE"
for ethX in ${ETH_FILENAME_ARRAY[@]}
do
  ethX=$(echo $ethX | awk -F"-" '{print $2}')
  grep $ethX "$TARGET_65ETH_FILE" | grep $ethX_id_hash["$ethX"] >/dev/null
  if [ $? -ne 0 ]; then
    chk_flag=$((chk_flag + 1))
  fi
done
if [ $chk_flag -eq 0 ]; then
  echo ">> [success] verified...[OK]."
else
  echo ">> [error] you need to correct manually($TARGET_65ETH_FILE)."
  echo "-----------------------------"
  cat $TARGET_65ETH_FILE
  echo "-----------------------------"
fi

exit 0
