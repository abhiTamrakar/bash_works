#!/bin/bash
#
#
# Version       :       1.0.1
# Summary       :       Generates Random Password based on the dictionary words
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

version=${version:-1.0.1}
creator=${creator:-Abhishek Tamrakar<abhishek.tamrakar08@gmail.com>}
specials='!1*#2$&3^%4@)5(+6-7_~8>9<?0'
header='%s: %s\n'
declare -a load_words sized_words
# end variables

usage()
{
cat << _EOF_

USAGE: 	${0##*/} [length of password] [no. of passwords to generate]
      	${0##*/} -l [length of password] -n [no. of passwords to generate]
	OPTIONS:
	-l	set length of passwords.
	-n	set number of passwords.
	-v	Make output verbose.
	-V	prints the version information and exit.

	DEFAULT: 
		Length of passwords=8
		Number of passwords=1

_EOF_
}

gethashes()
{
local_input=$1
echo $((local_input+=1)) > /dev/null

local_percent=$(echo "scale=1;$local_input / $pass_quantity * 100"|bc -l)

case $local_percent in
[0-9].0|1[0-9].0|20.0)
get_hashes="[=========>                             ]";;
2[1-9].0|3[0-9].0|40.0)
get_hashes="[===============>                       ]";;
4[1-9].0|5[0-9].0|60.0)
get_hashes="[====================>                  ]";;
6[1-9].0|7[0-9].0|80.0)
get_hashes="[==========================>            ]";;
8[1-9].0)
get_hashes="[================================>      ]";;
9[0-9].0|100.0)
get_hashes="[=======================================]";;
esac
echo -ne "${get_hashes} ${local_percent}%\r"
}

info()
{
printf "$header" "INFO" "$@"
}

error()
{
printf "$header" "ERROR" "$@"
exit 1;
}

thisprint()
{
printf '\n\n\t%s\n\t%s\n\n' "$@"
exit 0
}

check_integers()
{
case $1 in
[0-9]|[1-9][0-9])
[[ ${VERBOSE:-0} -eq 1 ]] && \
info Okay
;;
-h)
[[ ${VERBOSE:-0} -eq 1 ]] && \
info "Looking for help?"
;;
*)
error "Unexpected Non-Integer input parameter $1, see usage -h"
;;
esac
}


check_input()
{
if [[ $# -eq 0 ]]; then 
pass_length=8
pass_quantity=1
	elif [[ $# -eq 1 ]] && [[ $1 != "-h" ]] && [[ $1 != "-V" ]]; then
        pass_length=$1
	check_integers $pass_length
	[[ $pass_length -lt 8 ]] && \
        error "This script is not designed to generate weak passwords, minimum length should be 8"
        pass_quantity=1
		elif [[ $# -eq 2 ]]; then
	        pass_length=$1
        	pass_quantity=$2
		check_integers $pass_length
		check_integers $pass_quantity
		[[ $pass_length -lt 8 ]] && \
		error "This script is not designed to generate weak passwords, minimum length should be 8"
			elif [[ $# -gt 5 ]]; then
			error "Invalid no of arguments, see -h for help."
fi
}

make_passwd()
{
event=even
min_length=$((pass_length / 2))
evens=( $(for ((i=0;i<${min_length};i++)); do echo -n "$((i+=2)) ";i=$((i - 1)); done) )
odds=( $(for ((i=0;i<${min_length};i++)); do echo -n "$((i+=1)) "; done) )
even="${evens[@]}"
odd="${odds[@]/1/}"
count=$((${#sized_words[@]} - 1))

for item in $(seq 0 ${count}); do
lens=$(( ( RANDOM % $pass_length )  + 1 ))
if [[ "$event" = "even" ]]; then
event=odd
else
event=even
fi
	for len in ${!event}; do
	slen=$(( ( RANDOM % 26 )  + 1 ))
	replacable_char=$(echo ${sized_words[$item]}|cut -c$len)
	this_word=$(echo ${sized_words[$item]} |sed "s/$replacable_char/${specials:$slen:1}/;s/$replacable_char/\U&\E/")
	sized_words[$item]=$this_word
	done
pass_words=( ${pass_words[@]} ${this_word} )
done

}
# end functions

# check input
check_input $@

# getopts
while getopts ":l:n:vhV" atype
do
case $atype in
l )
        pass_length="$OPTARG"
	check_integers $pass_length
	[[ $pass_length -lt 8 ]] && \
	error "This script is not designed to generate weak passwords, minimum length should be 8"
        ;;
n )
        pass_quantity="$OPTARG"
	check_integers $pass_quantity
        ;;
h )
        usage
	exit 1
        ;;
v )	
	VERBOSE=1
        ;;
V ) 	
	thisprint "Version: ${version}" "Author: ${creator}"
	exit 0
	;;
\? )
	error "Unrecognised Option -${OPTARG}"
	;;
: )     
	error "Argument required !!! see \'-h\' for help"
        ;;
esac
done
shift $(($OPTIND - 1))

# main
# check the preinstalled dictionary and load words into an array.
thistime=$(date +%H:%M:%S)

[[ -L /usr/share/dict/words ]] || error "Cannot find any pre-installed dictionary!"

[[ ${VERBOSE:-0} -eq 1 ]] && \
info "Loading words, please wait"
load_words=( $(printf '%s ' $(cat /usr/share/dict/words| sed "s/'//g")) )

# find better length words
[[ ${VERBOSE:-0} -eq 1 ]] && \
info "Findings words of size ${pass_length}"
one_less_word=$((${#load_words[@]} - 1))
for w in $(seq 0 ${one_less_word})
do
slen=$(( ( RANDOM % ${one_less_word:-4} )  + 1 ))
	if [ $(echo -n ${load_words[$slen]}|wc -c) -eq ${pass_length:=8} ]
	then 
		
		sized_words=( ${sized_words[@]//\'/} ${load_words[$slen],,} )
			if [[ ${#sized_words[@]} -eq ${pass_quantity:=11} ]]; then
			echo -e "\n"
			break
			fi
		gethashes ${#sized_words[@]}
		sleep 1s
	else
	echo -ne "Start Time=> $thistime, Elapsed Time => $(date +%T) \r"
	fi
done

[[ ${VERBOSE:-0} -eq 1 ]] && \
{
	info "Below words were found"
	printf '%s\n' "${sized_words[@]}";
}

make_passwd
info "Passwords generated"
printf '%s\n' "${pass_words[@]}"
