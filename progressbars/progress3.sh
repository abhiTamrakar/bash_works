#!/bin/bash
#
# Author: Abhishek Tamrakar
# Summary: proress bar 3
# Type: with colored bar and percentage completion
##
# version: 1.0.0
#
##################################################
# variable here
n=''
i=0

# functions here

usage()
{
echo -e "USAGE: ${0##*/} -[nch]"
echo -e "
\t -n: no of iterations
\t -c: color of the progress bar
\t -h: displays this usage

"
exit 1
}

calcPer()
{
 local c=$1
 per=$(echo "scale=2;$c / $n * 100"|bc -l)
}

# check input
while [ $# -gt 0 ]
do
        case $1 in
                -n)
                        shift;
                        n=$1;;
                -c)
                        shift;
                        color=$1;;
                -h)     usage
                        ;;
                * )
                        n=$1;
                        color=white;;
        esac
shift

done

# main code goes here
# get color code
case $color in
        white)
                code=15
                ;;
        red)
                code=196
                ;;
        green)
                code=70
                ;;
esac


while [ $n -ge $i ]; do
 calcPer $i
 echo -en " checking $i/$n \r"
 sleep .5
 case ${per%.*} in
         [0-5])                 p='   ';;
         [6-9]|10)              p='       ';;
         1[1-9]|20)             p='           ';;
         2[1-9]|3[0-9]|40)      p='              ';;
         4[1-9]|5[0-9]|60)      p='                 ';;
         6[1-9]|7[0-9]|80)      p='                    ';;
         8[1-9]|9[0-5])         p='                       ';;
         9[6-9]|100)            p='                          ';;
 esac
 echo -ne " progress: [\e[48;5;${code}m$p\e[0m \c"
 echo -ne "${per%.*}%]\r"
# sleep .5
 echo $((i+=1)) >/dev/null
done
echo
