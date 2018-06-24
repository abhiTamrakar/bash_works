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
# test ascript for aray basics

declare -a arr
sum=0				# let the sum be 0

for ((i=1;i<=5;i++)); do
  read -p "enter ${i}'th array value: " arr[$i]
  sum=$((sum + ${arr[$i]}))
done						# read the values in array and calculate the sun on the go.

bigno=${arr[1]}					# set small and big no's to first array element by default
smallno=${arr[1]}

for j in $(seq 2 ${#arr[@]})			# start a loop to check with 2nd element, since first is already set.
do
  if [[ ${bigno} -lt ${arr[$j]} ]]		# check if value in big is lesser than the second element, if yes reset the bigno
  then
      bigno=${arr[$j]}
  elif [[ ${smallno} -gt ${arr[$j]} ]]		# check if value of smallno is bigger than the second element, if yes reset the smallno
  then
      smallno=${arr[$j]}
  elif [[ $smallno -gt ${bigno} ]]		# check if smallno is even bigger than bigno, if yes set the smallno.
  then
      smallno=${bigno}
  fi
done


printf '\n%s' "All array values enetered are: "

for i in ${!arr[@]}
do
  printf '\n%d => %s' "$i" "${arr[$i]}"
done

printf '\n\n%s\t%s' "total number of array elements: " "${#arr[@]}"
printf '\n%s\t%s' "total number of characters at index 5:"  "${#arr[5]}"
printf '\n%s\t%s' "Sum of all numbers in array:"  "${sum}"
printf '\n%s\t%s' "biggest number is:"  "${bigno}"
printf '\n%s\t%s\n\n' "smallest number is:"  "${smallno}"

