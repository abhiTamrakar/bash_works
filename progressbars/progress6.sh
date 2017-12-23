#!/bin/bash
#
# Author: Abhishek Tamrakar
# Summary: proress bar 6
# Type: with percentage completion
##
# version: 1.0.0
#
##################################################

n=$1
i=0
sp=" /-\|"

#
calcPer()
{
 local c=$1
 per=$(echo "scale=2;$c / $n * 100"|bc -l)
}

while [ $n -ge $i ]; do
 calcPer $i
 thistime=$(date +%T)
 sleep .2
 printf '%s' "["
 printf '\e[38;5;226m%s\e[0m%s' "Elapsed Time: $thistime" " ${sp:j++%${#sp}:1}]"
 printf '\e[38;5;226m%s\e[0m' "Checking Task: $i/$n"
 printf '%s\r' "|[${per%.*}%]"
 sleep .2
 echo $((i+=1)) >/dev/null
done
echo
