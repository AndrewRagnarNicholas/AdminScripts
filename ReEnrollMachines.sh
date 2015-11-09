#!/bin/bash
jssAddress="ADDRESSGOESHERE"
inviteID="INVITATIONIDGOESHERE"
currentUser=`stat -f "%Su" /dev/console`

##Source of this portion is from JAMF Nation post by Rich Trouton
jamfBinary=`/usr/bin/which jamf`

if [[ "$jamfBinary" == "" ]] && [[ -e "/usr/sbin/jamf" ]] && [[ ! -e "/usr/local/bin/jamf" ]]; then
   jamfBinary="/usr/sbin/jamf"
elif [[ "$jamfBinary" == "" ]] && [[ ! -e "/usr/sbin/jamf" ]] && [[ -e "/usr/local/bin/jamf" ]]; then
   jamfBinary="/usr/local/bin/jamf"
elif [[ "$jamfBinary" == "" ]] && [[ -e "/usr/sbin/jamf" ]] && [[ -e "/usr/local/bin/jamf" ]]; then
   jamfBinary="/usr/local/bin/jamf"
fi

###
 
"$jamfBinary" createconf -k -url "$jssAddress"
"$jamfBinary" enroll -invitation "$inviteID" -noRecon
"$jamfBinary" recon -endUsername "$currentUser"
"$jamfBinary" manage
