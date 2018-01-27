#!/bin/bash
#
#
# Version       :       1.0.1
# Summary       :       Checks integrity of passwords
#
# Copyright (C) 2017 Abhishek Tamrakar
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
##
# end declarations

#
# set variables
NAMES=( CHARACTER SPECIALS_ NUMERICAL UPPERCASE LOWERCASE )
WEIGHT=0
MESSAGE=''

# set functions
getWeight() {

local inputPassword=$1
local size=$2

MATCH=( "(?=^.{$size,255}$)" '(?=^[^\s]*$)' '(?=.*\d)' '(?=.*[A-Z])' '(?=.*[a-z])' )
echo -ne "\n\nINFO\tChecking Password Metrics |\c"
for m in ${!MATCH[@]}
do
	echo -ne ${inputPassword} \
		| grep -P "${MATCH[$m]}" \
		> /dev/null

	STATUS=$?

	case $STATUS in
	1 ) 
	VALUE=0
	FAILEDAT=( $FAILEDAT $m )
	echo -ne "\e[41m    \e[0m\c"
	;;
	0 ) 
	VALUE=1
	echo -ne "\e[42m      \e[0m\c"
	;;
	esac

	WEIGHT=$(echo "${WEIGHT/-/} + $VALUE"|bc -l)
sleep 1s
done
echo -ne "|\n"
}

help()
{
cat << EOF
	
	USAGE: ${0##*/} <input password>

EOF
exit 1
}

# main 
[ ! $1 ] && help || input=$1
TOTALCHAR=${#input}
getWeight $1 $TOTALCHAR

case ${TOTALCHAR} in
[1-7])
DIFF=3.5
MESSAGE="Password length should be at least 8 chars, your was $TOTALCHAR !!!"
;;
[8-9])
DIFF=2.5
MESSAGE="This is an average length password !"
;;
1[0-1])
DIFF=1.5
MESSAGE="Thats a good length, buddy !"
;;
1[2-9]|2[0-9]|3[0-9]|4[0-9]|5[0-9])
DIFF=0
MESSAGE="Excellent, you have a good sense of security !"
;;
esac

WEIGHT=$(echo "${WEIGHT/-/} - ${DIFF:-0}"|bc -l)
STRENGTH=$(echo -e "scale=2;${WEIGHT/-/} / ${#MATCH[@]} * 100"| bc -l)

case $STRENGTH in
[0-9].00|1[0-9].00|2[0-9].00|3[0-9].00) STR="Very Poor";;
4[0-9].00|5[0-9].00|6[0-9].00) STR="Poor";;
7[0-9].00) STR="Okay";;
8[0-9].00|9[0-5].00) STR="Good";;
100.00) STR="Excellent";;
esac

	[[ ${#FAILEDAT[@]} -ge 1 ]] && \
	{
		for metrics in ${FAILEDAT[@]}
		do
		 	printf '\n%s\t%s: %s' "INFO" "FAILED METRICS (At Least 1 Required)" "${NAMES[$metrics]}"
		done
	}

printf "\n\nINFO\tYour Password:\t%s\n\tStrength:\t%s\n\nNOTES\t%s\n\n" "${input}" "$STR" " ***$MESSAGE***"
