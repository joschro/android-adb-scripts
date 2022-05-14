#!/bin/sh

curlOptions="--connect-timeout 25"

test $# -lt 2 && {
        echo "Syntax: $(basename $0) <path-to-package-list> <priv|work>"
        exit
}
myFile="$1"
adb </dev/null shell dumpsys user | grep -i userinfo{
privUser=$(adb </dev/null shell dumpsys user | grep -i userinfo{ | grep "isPrimary=true" | sed "s/:.*//g;s/.*{//g")
workUser=$(adb </dev/null shell dumpsys user | grep -i userinfo{ | grep "Arbeitsprofil" | sed "s/:.*//g;s/.*{//g")
selectedProfile="$2"
test $selectedProfile = "priv" && myUser=$privUser
test $selectedProfile = "work" && myUser=$workUser

function testAppInstalled() {
	appID="$1"
	test "$(adb </dev/null shell pm path --user $myUser "$appID" | grep -w "$appID" | tr -d [:cntrl:] | head -n1)" && {
		echo "$appID already installed."
		return 0
	}
	return 1
}

function installApp() {
	appID="$1"
	echo "Testing for $appID in F-Droid store..."
	foundGooglePlayStore=False
	foundFdroidStore=True
	appName="$(curl $curlOptions -s "https://f-droid.org/packages/$appID/" | grep "<title>" | tr -d [:cntrl:] | sed "s/ |.*//g;s/.*>//g")"
	test "$appName" = "404 Page Not Found" -o "$appName" = "" && {
		echo "$appID does not exist in F-Droid store."
		foundFdroidStore=False
		foundGooglePlayStore=True
		echo "Testing for $appID in Google Play store..."
		appName="$(curl $curlOptions -s "https://play.google.com/store/apps/details?id=$appID" | grep "main-title" | sed "s/.*<title id=\"main-title\">//g;s/<.*//g")"
		test -n "$appName" || {
			echo "$appID does not exist in Google Play store."
			foundGooglePlayStore=False
		}
	echo "$appName - F-Droid: $foundFdroidStore Google: $foundGooglePlayStore" >&1
       	}
	test $foundGooglePlayStore = "True" -o $foundFdroidStore = "True" && {
		#	test -n "$(adb </dev/null shell pm path "$appID")" || {
		echo -n "Installing $appName for user $myUser: "
		echo "<adb </dev/null shell am start -a android.intent.action.VIEW -d \"market://details?id=$appID\">"
       		adb </dev/null shell am start --user $myUser -a android.intent.action.VIEW -d "market://details?id=$appID"
		echo
		test $foundFdroidStore = "True" && echo -e "---> PLEASE select F-DROID store to install: \"$appName\"! <---\n"
		test $foundGooglePlayStore = "True" && echo -e "---> PLEASE select GOOGLE PLAY store to install: \"$appName\"! <---\n"
	       	#while [ -z $(adb </dev/null shell pm path "$appID" | grep -w "$appID" | tr -d [:cntrl:] | head -n1) ]; do sleep 3; done
		return 0
	}
	test $foundGooglePlayStore = "False" -a $foundFdroidStore = "False" && return 1
}

#grep " $selectedProfile" $myFile | sed "s/ === /\t/g" $myFile | while IFS=$'\t' read myAppID appName storeFound userProfile
appListCount=0
while read lineOfFile
do
	myAppID="$(echo "$lineOfFile" | grep "= $selectedProfile" | sed "s/ .*//g")"
	test -n "$myAppID" || continue
	appList+="$myAppID "
	((appListCount++))
#done
done < $myFile

echo -e "AppList:\n$appList"
echo "Total number of apps: $appListCount"

appCount=0
for myAppID in $appList; do
	((appCount++))
	echo
	echo "----------------------------------------------------"
	testAppInstalled $myAppID
	test $? -eq 1 && {
		echo "Installing app $appCount of $appListCount"
		installApp $myAppID </dev/null
		test $? -eq 0 && {
			echo -n "Please press any key to continue"; read ANSW; echo "Proceeding..."
		}
	}
	echo "----------------------------------------------------"
	echo
done
#done < $myFile
