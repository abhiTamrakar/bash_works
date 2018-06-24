#!/bin/bash
#
#    Copyright (C) 2018  Abhishek Tamrakar <abhishek.tamrakar08@gmail.com>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
##

#	July 2016
#Su Mo Tu We Th Fr Sa
#                1  2
# 3  4  5  6  7  8  9
#10 11 12 13 14 15 16
#17 18 19 20 21 22 23
#24 25 26 27 28 29 30
#31


#get current month

#thismonth=$(date +%B' '%Y)

#[ ! $1 ] && read -p "year to query [xxxx]: " thatyear || thatyear=$1

declare -a months=(jan feb mar apr may jun jul aug sep oct nov dec)
declare -a alldays=(Sun Mon Tue Wed Thu Fri Sat)

calculateCal()
{
thatmonth=$1
thatyear=$2

case ${thatmonth,,} in
[Jj]an|[Mm]ar|[Mm]ay|[Jj]ul|[Aa]ug|[Oo]ct|[Dd]ec )
days=31
;;
[Aa]pr|[Jj]un|[Ss]ep|[Nn]ov )
days=30
;;
[Ff]eb )
year=$thatyear

if [ $[$year % 400] -eq "0" ]; then
days=29
elif [ $[$year % 4] -eq 0 ]; then
        if [ $[$year % 100] -ne 0 ]; then
days=29
        else
days=28
        fi
else
days=28
fi
;;
* )
echo -e "ERROR: incorrect month $thatmonth"
exit 1
;;
esac

printf '\n\n\n%10s %d\n' "${thatmonth^^}" "${thatyear}"
printf '\n%8s\t' "${alldays[*]}"
echo

for ((thisday = 1;thisday <= ${days}; thisday++))
do

thisdate="${thisday}-${thatmonth}-${thatyear}"
dayname=$(date -d "${thisdate}" +%a)
now=$(date +%d%m%Y)
convthisdate=$(date -d "${thisdate}" +%d%m%Y)

if [[ "${convthisdate}" = "${now}" ]]; then
today=yes
else 
today=no
fi

case ${dayname} in
Sun ) 
if [[ "$today" = 'yes' ]]; then 
header='\n\e[101m%2s\e[0m '
else
header='\n%2s '
fi
;;
Mon )
if [[ "$today" = 'yes' ]]; then
header='\e[101m%4s\e[0m '
else
header='%4s '
fi
if [[ $thisday -eq 1 ]]; then
printf '%2s' " "
fi;;
Tue ) 
if [[ "$today" = 'yes' ]]; then
header='\e[101m%4s\e[0m '
else
header='%4s '
fi
if [[ $thisday -eq 1 ]]; then
printf '%6s' "  "
fi;;
Wed )
if [[ "$today" = 'yes' ]]; then
header='\e[101m%4s\e[0m '
else 
header='%4s '
fi
if [[ $thisday -eq 1 ]]; then
printf '%10s' "   "
fi;;
Thu ) 
if [[ "$today" = 'yes' ]]; then
header='\e[101m%4s\e[0m '
else
header='%4s '
fi
if [[ $thisday -eq 1 ]]; then
printf '%14s' "    "
fi;;
Fri ) 
if [[ "$today" = 'yes' ]]; then
header='\e[101m%4s\e[0m  '
else
header='%4s '
fi
if [[ $thisday -eq 1 ]]; then
printf '%18s' "     "
fi;;
Sat ) 
if [[ "$today" = 'yes' ]]; then
header='\e[101m%4s\e[0m '
else
header='%4s\n'
fi
if [[ $thisday -eq 1 ]]; then
printf '%22s' "      "
fi;;
esac

printf $header "${thisday}"

done
echo
}


if [[ $# -eq 0 ]]; then 

cat << EOF
USAGE 1: $0 [MON] [YEAR]
USAGE 2: $0 [YEAR]

MON	:	month name in 3 chars
YEAR	:	year numerical in 4 digits

EOF

elif [[ $1 =~ ^[0-9]{1,4}$ ]]; then
thatyear=$1
for i in {0..11};
do
calculateCal ${months[$i]} ${thatyear}
done

elif [[ $1 =~ ^[A-Za-z]{1,3}$ ]] && [[ $2 =~ ^[0-9]{1,4}$ ]]; then 
thatmonths=$1
thatyear=$2
calculateCal ${thatmonths} ${thatyear} 

else 

echo -e "ERROR: Incorrect argument $1"
exit 1

fi
