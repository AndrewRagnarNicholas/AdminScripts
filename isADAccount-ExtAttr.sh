#!/bin/sh
currentUser=`ls -l /dev/console | cut -d " " -f 4`
currentUserID=$(dscl . -read /Users/$currentUser UniqueID | awk 'BEGIN {FS=": "} {print $2}')

if [ $currentUserID -gt 1000 ]; then
	echo "<result>AD User</result>"
else 
	echo "<result>Local Account</result>"
fi
