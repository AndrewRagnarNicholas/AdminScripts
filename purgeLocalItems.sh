#!/bin/sh
currentUser=`ls -l /dev/console | cut -d " " -f 4`
UUID=`system_profiler SPHardwareDataType | grep 'Hardware UUID' | awk '{print $3}'`
currentHome="/Users/$currentUser"
localItems="$currentHome/Library/Keychains"
badPath="$currentHome/Library/Keychains/BadLocalItems"

if [ -d $localItems ]; then
        echo "Creating BadLocalItems Folder"
        mkdir -p "$badPath"
        echo "Moving LOCKED local Items"
        mv -f $localItems "$badPath/$UUID-`date +%Y%m%d%H%M`"
        echo "Locked local items moved"
else
        echo "LocalItems Keychain has already been moved or deleted. Machine restart needed"
fi

