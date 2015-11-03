#!/bin/bash

# Set your default user profile

# Variables
picPath="/Library/ICF" #default is /tmp
picName="UserLogo.png"
userPics="/Library/User Pictures"
networkUserPic="/Library/User Pictures/$picName"

currentUser=`ls -l /dev/console | cut -d " " -f 4`
currentUID=$(dscl . -read /Users/$currentUser UniqueID | awk 'BEGIN {FS=":"} {print $2}')

# If the stock set is there, move it
if [[ ! -d "$userPics/Animals" && ! -d "$userPics/Flowers" && ! -d "$userPics/Fun" && ! -d "$userPics/Instruments" && ! -d "$userPics/Nature" ! -d "$userPics/Sports" ]]; then
	mv "$userPics" "Stock $userPics"
	mkdir -p "$userPics"
	# All new locally created accounts will get these pictures
	cp -fr "$logoPath" "$userPics" 
fi

# when the current user is a domain account, replace the user name
if [[ $currentUID -ge 1000 ]]; then
	currentPicture=$(dscl . -read /Users/$currentUser Picture | awk 'BEGIN {FS=":"} {printf $2}')
		if [[ "$currentPicture" != "No such key: Picture" ]]; then
			dscl . -create /Users/$currentUser Picture $networkUserPic
		fi
fi

