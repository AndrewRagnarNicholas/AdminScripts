#!/bin/bash

NetworkName="Shared" #Parallels Network Name (not adapter)
StartingIP="192.168.1.2" #First VM's IP
SM="24" #Subnet Mask
DHCPOnOff="on" #DHCP Server set to On/OFF
DHCPIP="192.168.1.1" #IP for Parallels to use as DHCP server
IPStart="192.168.1.1" #IP Range Start
IPEnd="192.168.1.254" #IP Range Stop

/usr/local/bin/prlsrvctl net set "$NetworkName" --ip "$StartingIP"/"$SM" --dhcp-server "$DHCPOnOff" --dhcp-ip "$DHCPIP" --ip-scope-start "$IPStart" --ip-scope-end "$IPEnd"