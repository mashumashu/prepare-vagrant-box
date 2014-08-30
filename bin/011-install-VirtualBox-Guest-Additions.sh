#!/bin/bash

readonly MOUNT_POINT="/mnt/cdrom"
readonly PACKAGE_ARRAY=( "gcc"
                         "kernel-devel" )
readonly REPO_NAME="$(lsb_release -i | awk -F" " '{print $3}')-dvd"

# main
restart_flag=0
for package in ${PACKAGE_ARRAY[@]}
do
  yum list installed | grep "^$package" >>/dev/null
  if [ $? -eq 0 ]; then
    echo ">> Already installed the package($package)."
  else
    echo ">> Install the package($package), because no installed required package."
    yum --disablerepo=\* --enablerepo=$REPO_NAME -y install $package
    restart_flag=$((restart_flag + 1))
  fi
done

if [ $restart_flag -ne 0 ]; then
  echo ">> [success] Please reboot and then re-run this script."
  exit 0
else
  echo ">> All required package installed."
  echo ">> Install the VirtualBox Guest Additions."
  export KERN_DIR=/usr/src/kernels/$(uname -r)
  mount /dev/cdrom $MOUNT_POINT
  $MOUNT_POINT/VBoxLinuxAdditions.run

  umount /mnt/cdrom
  echo ">> VBoxControl version"
  VBoxControl --version
  echo ">> VBoxService version"
  VBoxService --version
fi

exit 0
