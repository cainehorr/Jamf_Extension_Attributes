#!/bin/sh

#
# FILENAME: CrowdStrike_Falcon_Installation_Status.sh
# PURPOSE: Jamf Extension Attribute
# DESCRIPTION: Report CrowdStrike Falcon installation status
# WRITTEN BY: Caine Hörr
# WRITTEN ON: 2022-05-24
#

falcon_installation_path="/Applications/Falcon.app"

main(){
    run_as_root
    function_collect_data
}

run_as_root(){
    # Check for admin/root permissions
    if [ "$(/usr/bin/id -u)" != "0" ]; then
    	echo ""
        echo "[ERROR]: Script must be run as root or with sudo."
        echo ""
        exit 1
    fi
}

function_collect_data(){
	if [[ -d "${falcon_installation_path}" ]]; then
		echo "<result>Installed</result>"
	else
		echo "<result>Not Installed</result>"
	fi
}

main 

exit 0