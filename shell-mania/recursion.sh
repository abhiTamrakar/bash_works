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
count=1
test()
{
	read -p "enter no: " no

	echo $((no+=1))


	if [[ ${count} -eq 5 ]] 
	then 
		echo -e "\n\nno of attempts reached 5.. exiting"
		exit 1
	else 
		((count+=1))
		test
	fi 
}

test

