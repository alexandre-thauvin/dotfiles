#!/bin/bash
find ~/.android/avd -name "config.ini" | while read line
do
   awk '!/audio/' $line > tmp
   rm $line
   mv tmp $line
   echo "hw.audioInput = no" >> $line 
   echo "hw.audioOutput = no" >> $line 
done
