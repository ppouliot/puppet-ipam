#!/bin/bash

# Usage: ./convert-manifest.sh filename

# This script will take a csv containing hostname, static lease ip address, and MAC Address (in that order)  and convert it to the manifest format 
# MAC Addresses will be converted to aa:bb:cc:dd:ee:ff format if they do not contain a colon.  Additionally they will be converted to lowercase.  
# The output will be saved with the same base filename with a leases.yaml extension.  It will overwrite a current file with that name.
# The contents of this are meant to be appended in the static_leases section of a yaml file.

# Error checking is limited at this stage but will verify that IPs and MAC addresses appear to be the right format.


OUTPUT=$(echo "$1 " | sed 's/....$//')leases.yaml
echo "Output file = " $OUTPUT
touch $OUTPUT
echo "static_leases:
" > $OUTPUT

#Read in the variables one line at a time.  If your csv is in a diferent order, change the order the variables are read.
#If your separator is not , you can change the IFS value here

cat $1|while IFS="," read hostname ipaddr macaddr
do
    
#Convert MAC address to correct format
  if [ `echo $macaddr| grep "\:"` ]; then
		mac=$(echo $macaddr|tr '[:upper:]' '[:lower:]')
	else

#Final cut is needed because result was showing trailing : after conversion
    mac=$(echo $macaddr|sed 's![-.]!!g;s!\(..\)!\1:!g;s!:$!!'|cut -c 1-17|tr '[:upper:]' '[:lower:]')
	fi 

#Error checking to see if MAC address looks valid
	if [ `echo $mac | egrep "^([0-9a-f]{2}:){5}[0-9a-f]{2}$"` ]; then
                : 
        else
                mac=ERROR
	fi

#Error checking to see if IP address looks like valid format
	if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
		:
	else
		ip=ERROR
	
	fi

	echo "   $hostname:"
	echo "     mac: "\"$mac\"
	echo "     ip: $ipaddr"
	echo "" 
	echo "   $hostname:" >> $OUTPUT
	echo "     mac: "\"$mac\" >> $OUTPUT
	echo "     ip: $ipaddr" >> $OUTPUT
	echo ""  >> $OUTPUT
done
