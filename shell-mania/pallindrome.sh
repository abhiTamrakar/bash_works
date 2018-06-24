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
#
# test for palindrome

read -p "enter string: " str

len=${#str}					# get string length
mid=$(($len/2))					# get the mid value
i=0						# set counter to 0	
pal=1						# let say it is palindrome to ease our calculations

while [[ $i -lt $mid ]]				# start a loop till the mid value
do

last=$((len-(i+1)))				# set the last value to ensure we are checking from both directions

if [[ ${str:$i:1} != ${str:$last:1} ]]		# check first char with the last char
then 						#+ and second to second last and so on.
pal=0						# if all matches the string palindrome otherwise not.
fi

((i+=1))					# increament counter anyways

done

if [[ $pal -eq 1 ]]
then 
echo "$str is a palindrome"
else
echo "$str is not a palindrome"
fi

