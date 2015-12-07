#!/bin/sh

# 
# Mac Mini Kiosk Settings
# ARN 12.02.2015
# Use at your own risk. I assume no responsibility for loss or damage caused by this script
# 

## Variables ##
#KioskAccount
kioskAccount="kioskUser"
kioskPassword="YOURP@55W0RD"
kioskHome="/Users/$kioskAccount"
kioskAccountTest=`dscl . -list /Users | grep $kioskAccount`
kisokAccountUID=`id -u $kioskAccount`
#AdminAccount
adminAccount="adminUser" 
adminPassword="YOURP@55W0RD"
adminHome="/Users/$adminAccount"
adminAccountTest=`dscl . -list /Users | grep $adminAccount`
#System Variables
OSVer=$(sw_vers -productVersion | awk -F. '{print $2}')
logFile="/var/log/miniSettings.log"
timeZone="America/Chicago"

# Create the Logfile and timestamp it
touch $logFile
echo `date +%Y%m%d%H%M` >> $logFile

#move the existing autologin PW if one exists
if [ -e /private/etc/kcpassword ]; then
	mv /private/etc/kcpassword /private/etc/kcpassword.bak
fi

## CreateAccounts ##
if [[ $OSVer -ge "10" ]]; then
	if [ "$adminAccounTest" == "" ]; then
		sysadminctl -addUser $adminAccount -fullName "$adminAccount" -password "$adminPassword" -home "$adminHome" -admin
		createhomedir -c > /dev/null
		echo "Admin Account Added" >> $logFile
	else
		echo "Admin account exists" >> $logFile		
	fi
	if [ "$kioskAccountTest" == "" ]; then
		sysadminctl -addUser $kioskAccount -fullName "$kioskAccount" -password "$kioskPassword" -home "$kioskHome"
		createhomedir -c > /dev/null
		echo "Kiosk Account added" >> $logFile
	else
		echo "Kiosk Account exists" >> $logFile
	fi
else 
	echo "All Machines Should be at least 10.10. Please upgrade machine" >> $logFile
	exit 1 
fi

## Power Setting ##
# Turns off Display Sleep, Disk Sleep, Sleep. Enable auto-restart in the event of a power failure
pmset -a displaysleep 0 disksleep 0 sleep 0 autorestart 1 
echo "Power settings set" >> $logFile

## Login Screen Setting ##
# Enable admin info at the Login Window
defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
echo "Login screen settings applied" >> $logFile

# Show name and password fields
defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool yes
echo "Name and Password fields by default" >> $logFile

# Show shut down etc. buttons
defaults write /Library/Preferences/com.apple.loginwindow PowerOffDisabled -bool false
echo "Shutdown buttons shown" >> $logFile

# Disable Password Hints
defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0
echo "Password hints disabled" >> $logFile

# No Shared Accounts
defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool no
defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool no
echo "Shared accounts disabled" >> $logFile

# Enable Auto-Login and Prevent Autologout
defaults write /Library/Preferences/.GlobalPreferences com.apple.userspref.DisableAutoLogin -bool false
defaults write /Library/Preferences/com.apple.loginwindow "autoLoginUser" "$kioskAccount"
defaults write /Library/Preferences/com.apple.loginwindow.plist "autoLoginUserUID" "$kioskAccountUID"
defaults write /Library/Preferences/.GlobalPreferences com.apple.autologout.AutoLogOutDelay -int 0
#password needs to be delivered via captured or edited /etc/kcpassword file
echo "Autologin enabled for $kioskAccount" >> $logFile

## Generic settings
# Set timezone to Desired time
systemsetup -settimezone $timeZone 
echo "Timezone Set to $timeZone" >> $logFile

# Turn off Screen Saver and Screen Saver Lock
defaults write /Library/Preferences/com.apple.screensaver.plist askForPassword 0
defaults -currentHost write com.apple.screensaver idleTime 0
echo "Kiosk Account screensaver disabled"

# Enable Remote Access
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -allowAccessFor -specifiedUsers 
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -access -on -privs -all -users "$adminAccount","$kioskAccount"
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate
echo "Remote Access enabled" >> $logFile

# Enable shell access
systemsetup -setremotelogin on
echo "Shell access enabled"  >> $logFile

exit 0
