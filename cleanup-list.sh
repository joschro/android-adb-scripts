#!/bin/sh

sort -u "$1" | sed "s/\&amp;//g" > "$1.sorted"
mv "$1.sorted" "$1"
