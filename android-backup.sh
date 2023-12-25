#!/bin/sh

adb devices | grep device | grep -v attached || exit
myPATH="$(adb shell getprop ro.product.model)/$(date +"%Y-%m-%d")"
mkdir -p "$myPATH"
adb shell getprop ro.build.version.release > "$myPATH"/version.txt
adb shell dumpsys battery > "$myPATH"/battery.txt
~/bin/adb-list-installed-packages.sh > "$myPATH"/packagelist-full.list
sed "s/.*=//g" "$myPATH"/packagelist-full.list > "$myPATH"/packagelist-simple.list

