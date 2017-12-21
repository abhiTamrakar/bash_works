#!/bin/bash
#
# Author: Abhishek Tamrakar
# Summary: proress bar 2
# Type: #'s with percentage completion
##
# version: 1.0.0
#
##################################################

n=$1
i=0
sp="#/-\|"

#
calcPer()
{
 local c=$1
 per=$(echo "scale=2;$c / $n * 100"|bc -l)

}

while [ $n -ge $i ]; do
 calcPer $i
 echo -en " checking $i/$n \r"
 sleep .2
 case ${per%.*} in
         [0-5])                 p='#';;
         [6-9]|10)              p='###';;
         1[1-9]|20)             p='#######';;
         2[1-9]|3[0-9]|40)      p='###########';;
         4[1-9]|5[0-9]|60)      p='##############';;
         6[1-9]|7[0-9]|80)      p='##################';;
         8[1-9]|9[0-5])         p='#######################';;
         9[6-9]|100)            p='############################';;
 esac
 echo -ne "[ progress: $p${sp:j++%${#sp}:1} \c"
 echo -ne "${per%.*}%]\r"
 sleep .2
 echo $((i+=1)) >/dev/null
done
echo
