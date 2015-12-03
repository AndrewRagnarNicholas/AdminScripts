#!/bin/bash

# Created by Andrew Nicholas
# Use at your own risk. I assume no responsibility for loss or damage caused by this script

#Variables
ENABLEREMOTEMANAGE=true
FIREWALLON=true
ADMINUSER=""
LOGINTEXTLINE1=""
LOGINTEXTLINE2=""
LOGINTEXTLINE3=""

#####################
### User Settings ###
#####################
# Add User Template Items for all accounts
# Root borrowed from rtrouten
# Determine OS version
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')
sw_vers=$(sw_vers -productVersion)
for USER_TEMPLATE in "/System/Library/User Template"/*
	do
	# Add Bluetooth and Volume to Taskbar
    	defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.systemuiserver.plist menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Volume.menu"
    	defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.systemuiserver.plist menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"
	 # Turn off iCloud
    	defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant DidSeeCloudSetup -bool TRUE
    	defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant GestureMovieSeen none
    	defaults write "${USER_TEMPLATE}"/Library/Preferences/com.apple.SetupAssistant LastSeenCloudProductVersion "${sw_vers}"
	# Turn off .DS_Store written to network shares
	defaults write "${USER_TEMPLATE}"/Library/Preferences/.GlobalPreferences DSDontWriteNetworkStores -bool TRUE
done

########################
### Machine Settings ###
########################

## Login Settings ##
# Write Login Banner
defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "$LOGINTEXTLINE1 \n $LOGINTEXTLINE2 \n $LOGINTEXTLINE3"

# Disable auto-login
defaults write /Library/Preferences/.GlobalPreferences com.apple.userspref.DisableAutoLogin -bool true

# Display login/password
defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool yes

# Disable Show Password Hints
defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0

# Enable Screen Saver after X seconds
osascript -e 'tell application "System Events" to set delay interval of screen saver preferences to 300'

# Enable Account Prompting
osascript -e 'tell application "System Events" to set require password to wake of security preferences to true'

# Disable auto logout after a period of inactivity 
defaults write /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLogOutDelay -int 0

# Disable Guest Account access to shared folders
defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool no
defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool no

## Configuration Settingsis the new machine w ##
# On Battery Settings - Put disk to sleep after 10 minutes. Dim Screen on Battery
pmset -b disksleep 10 lessbright 1
# All Power Configurations. Display Sleep on 5, sleep on 30, Wake On LAN on
pmset -a displaysleep 5 sleep 30 womp 1

# Enable Network Time
systemsetup -setusingnetworktime on

# Let all users add a printer (but not a driver)
dseditgroup -o edit -n /Local/Default -a everyone -t group lpadmin

## Security Settings ##
# Enable RemoteManagement
if [ $ENABLEREMOTEMANAGE == true ]; then
	if [ "$ADMINUSER" != "" ]; then
		/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -specifiedUsers $ADMINUSER -privs -all
	else
		/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -allowAccessFor -allUsers -privs -all
	fi
fi

# Firewall for essential Services 
if [ $FIREWALLON == true ]; then
	defaults write /Library/Preferences/com.apple.alf globalstate -int 1
fi
