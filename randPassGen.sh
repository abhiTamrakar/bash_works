#!/bin/bash
#
#
# Version	:	1.0.1
# Summary	:	Generates Random Password
#
# Copyright (C) 2016 Abhishek Tamrakar
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

checkNreadseq()
{
cat << _EOF_

USAGE: ${0##*/} [no. of passwords to generate]

_EOF_

read -p "Enter No of Passwords To Generate: " n
}


passw()
{
LENGTH=8
MIN_U=1
MIN_L=1
MIN_D=1
MIN_S=1

for i in $(tr -cd '#_%&A-Za-z0-9' < /dev/urandom | fold -w $LENGTH | head -20)
do
UPPERS=$(echo $i |  awk '{print gsub(/[A-Z]/,"")}')
LOWERS=$(echo $i |  awk '{print gsub(/[a-z]/,"")}')
DIGITS=$(echo $i |  awk '{print gsub(/[0-9]/,"")}')
SPECIAL=$(echo $i | awk '{print gsub(/[#$@!()*&^%]/,"")}')

if [ $UPPERS -ge $MIN_U -a $LOWERS -ge $MIN_L -a $DIGITS -ge $MIN_D -a $SPECIAL -eq $MIN_S ];then
if [[ ! "$i" =~ ^[0-9] ]]; then
        if [[ ! "$i" =~ ^[#_%$] ]]; then
FOUND=1; break
                fi
        fi
fi
done

if [  -z $FOUND ];then
echo "ERROR: could not generate appropriate password"
else
echo "$i"
fi
}

[[ ! $1 ]] && checkNreadseq || n=$1

for j in $(seq $n)
do
passw
done
