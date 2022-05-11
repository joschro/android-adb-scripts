#!/bin/sh

# https://stackpointer.io/mobile/android-adb-list-installed-package-names/416/

adb shell pm list packages -e -3 -f
