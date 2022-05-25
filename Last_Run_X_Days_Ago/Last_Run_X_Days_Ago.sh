#!/bin/sh

####################################################################################################
#
# Last_Run_X_Days_Ago.sh
#
####################################################################################################
#
# DESCRIPTION
#
# 	Determine if an app has been used within the past X days.
# 	Calculate how many days ago it was last ran.
#
####################################################################################################
#
# CHANGE CONTROL LOG
#	Version 1.0 - 2020-02-03
# 		Created by Caine Hörr
#			Initial script creation
#

#
# FEEL FREE TO EDIT DOWN HERE...
#

# Enter the path to the application bundle to check on, including the .app extension
appPath="/Applications/Microsoft Excel.app"

#
# NO USER SERVICEABLE PARTS PAST THIS LINE...
#

main(){
	sanityCheck
	finalOutput
}

sanityCheck(){
	if [ ! -d "$appPath" ]; then
		# If app not found, set integer value to as -1
		appUsedDaysAgo="-1"
	else
		bustTheMaths
	fi
}

bustTheMaths(){
	# Acquire Current Date
	currentDate=$(date +%Y-%d-%m)

	# Get the LastUsedDate as reported by mdls
	appLastUsedDate=$(mdls "$appPath" -name kMDItemLastUsedDate | awk '{ print $3 }')

	# Determine the type of meta data accociated with appLastUsedDate
	if [[ "${appLastUsedDate}" != "not find" ]] && [[ "${appLastUsedDate}" != "(null)" ]] && [[ ! -z "$appLastUsedDate" ]]; then
    	# If appLastUsedDate is an actual date, do this stuff...
    	# Parce the date into individual elements
		IFS=- read lastUsedYear lastUsedMonth lastUsedDay <<< "${appLastUsedDate}"

		# Recompile date into YY-dd-mm format
		appLastUsedDate="${lastUsedYear}-${lastUsedDay}-${lastUsedMonth}"
	else
		# If appLastUsedDate is not an actual date, do this stuff...
		# Date of the Epoch
    	appLastUsedDate="1970-01-01"
	fi

	# Convert currentDate to Epoch Date
	currentDateEpoch=$(date -jf %Y-%d-%m ${currentDate} +%s)

	# Convert appLastUsedDate to Epoch Date
	appLastUsedDateEpoch=$(date -jf %Y-%d-%m ${appLastUsedDate} +%s)

	# Bust the math and determine number of days since last use
	# This is an integer value - great for Jamf Extension Attribute
	appUsedDaysAgo=$(((`date -jf %Y-%d-%m ${currentDate} +%s` - `date -jf %Y-%d-%m ${appLastUsedDate} +%s`)/86400))
}

finalOutput(){
	echo "<result>${appUsedDaysAgo}</result>"
}

main

exit
