#!/bin/bash

readonly OS=$(lsb_release -i | awk -F" " '{print $3}')
readonly OS_VERSION=$(lsb_release -r | sed 's/^.*\([0-9]\)\.\([0-9]\)\.*$/\1.\2/')
readonly CPU=$(uname -m)
readonly TARGET_FILE="/etc/yum.repos.d/$OS-dvd.repo"
readonly MOUNT_POINT="/mnt/cdrom"
readonly BASEURL="file://${MOUNT_POINT}"
readonly GPGKEY="${BASEURL}/RPM-GPG-KEY-$OS-"$(echo $OS_VERSION | awk -F"." '{print $1}')

# main
if [ ! -d $MOUNT_POINT ]; then
  echo ">> Make directory, because nothing $MOUNT_POINT"
  mkdir -p $MOUNT_POINT
fi

mount /dev/cdrom $MOUNT_POINT
mount | grep "/dev/sr0 on $MOUNT_POINT" >/dev/null
if [ $? -ne 0 ]; then
  echo ">> [error] No mount the DVD to $MOUNT_POINT(exit=1)"
  echo ">> Please mount the DVD to $MOUNT_POINT and then re-run this script."
  exit 1
fi

rm -f $TARGET_FILE
if [ ! -f "$TARGET_FILE" ]; then
  echo ">> Create a new file($TARGET_FILE), because no such a file."
  {
    echo "# To use this repo, put in your DVD and use it with the other repos too:"
    echo "#  yum --enablerepo=c6-media [command]"
    echo "#"
    echo "# or for ONLY the media repo, do this:"
    echo "#"
    echo "#  yum --disablerepo=\* --enablerepo=c6-media [command]"
    echo ""
    echo "[$OS-dvd]"
    echo "name=$OS-$OS_VERSION - $CPU - DVD"
    echo "baseurl=${BASEURL}"
    echo "enabled=1"
    echo "gpgcheck=1"
    echo "gpgkey=${GPGKEY}"
  } >>$TARGET_FILE
fi

# verify
echo ""
echo ">> verify $TARGET_FILE manually!"
echo "-----------------------------"
cat $TARGET_FILE
echo "-----------------------------"
echo ""

echo ">> yum clean all"
yum clean all

exit 0
