#!/bin/sh

test $# -lt 2 && {
	echo "Please provide parameters for [priv|work] profile and path to backup files"
	exit
}

myProfile="$1"

myPATH="$2"
test -f "$myPATH" && myFILE="$myPATH"
test -d "$myPATH" && myFILE="$myPATH"/packagelist-simple.list

echo "$(dirname $0)/adb-install-packages.sh $1 \$(cat "$myFILE")"
sh "$(dirname $0)/adb-install-packages.sh" $1 $(cat "$myFILE" | tr "\n\r" " ")
