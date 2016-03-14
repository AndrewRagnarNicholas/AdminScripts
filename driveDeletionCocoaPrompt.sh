#!/bin/bash
osascript -e 'tell app "Terminal" to set miniaturized of every window to true' 

cocoa="/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog"

rv=`$cocoa yesno-msgbox --title "Deletion Confirmation" --text "PLEASE READ" --informative-text "This will DELETE the main drive on this computer. This is UNRECOVERABLE." --no-cancel --icon hazard --float --string-output` 

if [ $rv == "Yes" ]; then

	diskutil unmountDisk force /dev/disk0
	diskutil eraseDisk JHFS+ Macintosh\ HD /dev/disk0
	$cocoa ok-msgbox --title "Deletion Confirmation" --text "Completed" --informative-text "This Drive has been successfully deleted. Please begin imaging processes." --no-cancel --icon info --float
	
	killall Terminal	
else
	killall Terminal
fi