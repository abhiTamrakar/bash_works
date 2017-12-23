#!/bin/bash
#
# Author: Abhishek Tamrakar
# Summary: proress bar 5
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
 sleep .5
 printf "|\e[48;5;${code}m%${per%.*}s\e[31m${per%.*}" 
 printf '%s\e[0m%s\r' "%" "|" 
 echo $((i+=1)) >/dev/null
done
printf '\n'
