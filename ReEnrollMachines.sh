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
 
"$jamfBinary/jamf" createconf "$jssAddress"
"$jamfBinary/jamf" enroll -invitation "$inviteID"
"$jamfBinary/jamf" recon -endUsername
