#!/bin/sh

test $# -lt 1 && {
	echo "Please provide path to backup files"
	exit
}

myPATH="$1"
test -f "$myPATH" && myFILE="$myPATH"
test -d "$myPATH" && myFILE="$myPATH"/packagelist-simple.lst

echo "~/bin/adb-install-packages.sh $(cat "$myFILE")"
~/bin/adb-install-packages.sh $(cat "$myFILE" | tr "\n\r" " ")
