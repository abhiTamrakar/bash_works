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
#make a triangle with *

#read a value to get no of stars in teh lowest orbit. 

read -p "how much big triangle do you want to build (answer in no of starts, 40 is the top limit!!) ? " no

if [[ $no -gt 40 ]] 	#check teh top limit 
then 
  echo -e "you reached the top limit!!!"
  exit 1	# exit if top is reached
else 
  echo -e "\n\n" 			# print two blank lines to give a good space for pattern
fi

((no-=1))			# decreament the total counter by 1 to start with a count of 0

for i in $(seq 0 $no); 		# start first loop from 0 to new value of $no
do 
  n=$(expr $i + 1)		# increament the counter by 1 to print inner walls. 
  for j in $(seq 1 $n);		# start new loop to start printing the stars with new counter. 
  do 
    echo -e "* \c" 			# print starts and make sure to keep the same line unless one lines gets complete..
  done
  echo -ne "\n"			# make sure to change the line on completion of previous one.
done

