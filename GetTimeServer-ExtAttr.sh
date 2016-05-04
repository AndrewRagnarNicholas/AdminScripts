#!/bin/sh

NetworkTimeIs="`systemsetup -getusingnetworktime | awk '{print $3}'`"
timeserverResut=""

if [ "$NetworkTimeIs" == "On" ]; then
	timeserverResult="`systemsetup -getnetworktimeserver | awk '{print $4}'`"
else
	timeserverResult="none"
fi

echo "<result>$timeserverResult</result>"

	