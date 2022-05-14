#!/bin/sh

test $# -lt 2 && {
	echo "Syntax: $(basename $0) <path to package-list> <priv|work>"
	exit
}

myFile="$1"
userProfile="$2"

while read lineOfFile
do
	storeFound=""
	appName="$(curl -s "https://f-droid.org/packages/$lineOfFile/" | grep "<title>" | tr -d [:cntrl:] | head -n1 | sed "s/ |.*//g;s/.*>//g")"
	test "$appName" = "404 Page Not Found" || storeFound="F-Droid"
	test "$storeFound" || {
	       appName="$(curl -s "https://play.google.com/store/apps/details?id=$lineOfFile" | tr -d [:cntrl:] | head -n1 | grep "main-title" | sed "s/.*<title id=\"main-title\">//g;s/<.*//g;s/ - Apps on Google Play//g")"
		test -n "$appName" && storeFound="GooglePlay"
	}
	echo "$lineOfFile === $appName === $storeFound === $userProfile"
done < $myFile
