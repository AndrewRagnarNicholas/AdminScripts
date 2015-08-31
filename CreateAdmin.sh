#!/bin/bash

#Variables
OSVer=$(sw_vers -productVersion | awk -F. '{print $2}')
HostName=`scutil --get ComputerName`
AdminName=""
AdminPassword=""
AdminHome="/var/.$AdminName"
AdminUID="500"
AdminShell="/bin/bash"
AdminHidden=true
dsclUser="/Users/"$AdminName

# Add admin user. All users <500 are automatically hidden
if [ $AdminHidden == true ]; then 
	AdminUID=$(dscl . -list /Users UniqueID | sort -n -k 2 | awk 'BEGIN{i=400}{if($2>400 && $2<500)i=$2}END{print i+1}')
else
	AdminUID=$(dscl . -list /Users UniqueID | sort -n -k 2 | awk 'BEGIN{i=500}{if($2>500 && $2<1000)i=$2}END{print i+1}')
fi

# Starting at 10.10 this got easier but 10.7-10.9 are supported in the old method
if [[ $OSVer -gt "7" && $OSVer -lt "10" ]]; then
	#Create Account
	dscl . -create $dsclUser
	dscl . -create $dsclUser UserShell "$AdminShell"
	dscl . -create $dsclUser RealName "$AdminName"
	dscl . -create $dsclUser UniqueID "$AdminUID"
	dscl . -create $dsclUser PrimaryGroupID 1000
	dscl . -create $dsclUser NFSHomeDirectory "$AdminHome"
	createhomedir -c > /dev/null
	#SetPassword
	dscl . -passwd $UserDirectory "$AdminPassword"
	#Add to local admin group
	dscl . append /Groups/admin GroupMembership "$AdminName"
elif [[ $OSVer -ge "10" ]]; then
	sysadminctl -addUser $AdminName -fullName "$AdminName" -UID "$AdminUID" -password "$AdminPassword" -home "$AdminHome" -admin
	createhomedir -c > /dev/null
fi