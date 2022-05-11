#!/bin/sh

myPATH="$(adb shell getprop ro.product.model)/$(date +"%Y-%m-%d")"
mkdir -p "$myPATH"
adb shell getprop ro.build.version.release > "$myPATH"/version.txt
adb shell dumpsys battery > "$myPATH"/battery.txt
~/bin/adb-list-installed-packages.sh > "$myPATH"/packagelist-full.lst
sed "s/.*=//g" "$myPATH"/packagelist-full.lst > "$myPATH"/packagelist-simple.lst
