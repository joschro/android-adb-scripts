#!/bin/sh

myIP=$1
shift
myDir=/sdcard/

echo "Syntax: $0 <IP address> [remote files/dir]"
echo "        copies remote files/dir to current directory"
test $# -gt 0 && myDir=$1

rsync -e "ssh -p 2222" -vauP $myIP:$myDir .
