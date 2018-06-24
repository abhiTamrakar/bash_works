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
# script to use select
opts="red black white brown"
select opt in ${opts}; do

if [[ "${opt}" =  "red" ]]
then
  echo "you chose ${opt}"
elif [[ "${opt}" =  "black" ]]
then
  echo "you chose ${opt}"
elif [[ "${opt}" =  "white" ]]
then
  echo "you chose ${opt}"
elif [[ "${opt}" =  "brown" ]]
then
  echo "you chose ${opt}"
else
  clear
  echo "your choice was invalid"
  exit 1;
fi
done

