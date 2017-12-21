#!/bin/bash
#
# Author: Abhishek Tamrakar
# Summary: proress bar 1
# Type: With percentage completion
##
# version: 1.0.0
#
##################################################

n=$1
i=0
calcPer()
{
 local c=$1
 per=$(echo "scale=2;$c / $n * 100"|bc -l)
# echo -n "[$per %]"
}

while [ $n -ge $i ]; do
 calcPer $i
 echo -en "checking status of $i/$n \t[${per%.*}%]\r"
 sleep .5
 echo $((i+=1)) >/dev/null
done
echo
