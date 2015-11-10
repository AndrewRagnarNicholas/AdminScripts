#!/bin/sh

osVers=$(sw_vers -productVersion | awk -F. '{print $2}')
picLoc="/path/to/picture.jpg"

#For El Capitan update the default wallpaper by replacing file the symlink points to
#For everything else, just replace the symlink

#Replace the Default Picture
if [[ $osVers == 11 ]]; then

    mv /Library/Desktop\ Pictures/El\ Capitan.jpg /Library/Desktop\ Pictures/El\ Capitan.bak.jpg
    mv "$picLoc" /Library/Desktop\ Pictures/El\ Capitan.jpg

elif [[ $osVers -lt 10 ]]; then

    #Replace the Default Desktop Link
    ln -fs "$picLoc" /System/Library/CoreServices/DefaultDesktop.jpg

fi