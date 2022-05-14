#!/bin/sh

test "$1" = "priv" && myUser=$(adb shell dumpsys user|grep -i userinfo{ | grep "isPrimary=true" | sed "s/:.*//g;s/.*{//g")
test "$1" = "work" && myUser=$(adb shell dumpsys user|grep -i userinfo{ | grep "Arbeitsprofil" | sed "s/:.*//g;s/.*{//g")
shift

for APP_NAME in $*; do
	echo
	echo "----------------------------------------------------"
       	adb shell pm path "$APP_NAME" | grep -w "$APP_NAME" >/dev/null && echo "$APP_NAME already installed." && continue
	echo "Testing for $APP_NAME in F-Droid store..."
	foundGooglePlayStore=True
	foundFdroidStore=True
	appName="$(curl -s "https://f-droid.org/packages/$APP_NAME/" | grep "<title>" | tr -d [:cntrl:] | head -n1 | sed "s/ |.*//g;s/.*>//g")"
	test "$appName" = "404 Page Not Found" && {
		echo "$APP_NAME does not exist in F-Droid store."
		foundFdroidStore=false
		echo "Testing for $APP_NAME in Google Play store..."
		appName="$(curl -s "https://play.google.com/store/apps/details?id=$APP_NAME" | grep "main-title" | tr -d [:cntrl:] | head -n1 | sed "s/.*<title id=\"main-title\">//g;s/<.*//g")"
		test -n "$appName" || {
			echo "$APP_NAME does not exist in Google Play store."
			foundGooglePlayStore=false
			continue
		}
       	}
#	test -n "$(adb shell pm path "$APP_NAME")" || {
	echo -n "Installing $appName : "
       	echo "<adb shell am start -a android.intent.action.VIEW -d \"market://details?id=$APP_NAME\">"
       	adb shell am start --user $myUser -a android.intent.action.VIEW -d "market://details?id=$APP_NAME"
	echo
	test $foundFdroidStore == "True" && echo -e "---> PLEASE select F-DROID store to install: \"$appName\"! <---\n"
	test $foundGooglePlayStore == "True" && echo -e "---> PLEASE select GOOGLE PLAY store to install: \"$appName\"! <---\n"
	
	read ANSW
               	#sleep 5
#	       	while [ -z $(adb shell pm path "$APP_NAME") ]; do sleep 10; done
#	       	sleep 15
#        }
	echo "----------------------------------------------------"
	echo
done
