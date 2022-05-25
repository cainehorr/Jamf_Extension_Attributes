#!/bin/sh

#
# FILENAME: CrowdStrike_Falcon_Connection_State.sh
# PURPOSE: Jamf Extension Attribute
# DESCRIPTION: Report CrowdStrike Falcon Connection State
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
		falcon_connection_state="$(/usr/bin/sudo /Applications/Falcon.app/Contents/Resources/falconctl stats Communications | /usr/bin/grep -i "State:" | /usr/bin/awk '{print $2}')"
		echo "<result>${falcon_connection_state}</result>"
	else
		echo "<result>N/A</result>"
	fi
}

main 

exit 0