#!/bin/sh

for APP_NAME in $*; do
	echo
	echo "----------------------------------------------------"
	echo "Testing for $APP_NAME in F-Droid store..."
	curl -s "https://f-droid.org/packages/$APP_NAME" | grep "Not Found" >/dev/null && {
		echo "$APP_NAME does not exist in F-Droid store."
		echo "Testing for $APP_NAME in F-Droid store..."
		curl -s "https://play.google.com/store/apps/details?id=$APP_NAME" | grep "Not Found" >/dev/null && {
			echo "$APP_NAME does not exist in Google Play store."
			continue
		}
		echo "Success! $APP_NAME was found in Google Play store!"
       	}
	echo "Success! $APP_NAME was found in F-Droid store!"
#	test -n "$(adb shell pm path "$APP_NAME")" || {
	echo -n "Installing $APP_NAME... "
       	echo "Befehl: "; echo "adb shell am start -a android.intent.action.VIEW -d \"market://details?id=$APP_NAME\""
       	adb shell am start -a android.intent.action.VIEW -d "market://details?id=$APP_NAME"
	read ANSW
               	#sleep 5
#	       	while [ -z $(adb shell pm path "$APP_NAME") ]; do sleep 10; done
#	       	sleep 15
#        }
        echo "$APP_NAME already installed."
	echo "----------------------------------------------------"
	echo
done
