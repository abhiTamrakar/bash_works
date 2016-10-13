#!/bin/bash - 
#===============================================================================
#
#          FILE: genSSLcsr.sh
# 
#         USAGE: ./genSSLcsr.sh [options] 
# 
#   DESCRIPTION: ++++version 1.0.2
# 		Fixed few bugs from previous script
#		+Removing passphrase after CSR generation
# 		Extended use of functions
# 		Checks for valid common name
#		++++1.0.3
# 		Fixed line breaks
# 		Work directory to be created at the start
# 		Used getopts for better code arrangements
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Abhishek Tamrakar (), abhishek.tamrakar08@gmail.com
#  ORGANIZATION: Self
#       CREATED: 6/24/2016
#      REVISION: 3
# COPYRIGHT AND 
#	LICENSE: Copyright (C) 2016 Abhishek Tamrakar
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#===============================================================================

#variables ges here
#set basename to scriptname
SCRIPT=${0##*/}

#set flags
TFOUND=0
CFOUND=0
MFOUND=0
XFOUND=0
logdir=/var/log
# edit these below values to replace with yours
homedir=
yourdomain=
country=IN
state=Maharashtra
locality=Pune
organization="your_organization"
organizationalunit="your_organizational_unit"
email=your_email@your_domain
password=your_ssl_password
# OS is declared and will be used in its next version
OS=$(egrep -io 'Redhat|centos|fedora|ubuntu' /etc/issue)

### function declarations ###

info()
{
printf '\n%s\t%s\t' "INFO" "$@"
}

#exit on error with a custom error message
#the extra function was removed and replaced withonly one.
#using FAILED\n\e<message> is a way but not necessarily required. 
#

fatal()
{
 printf '\n%s\t%s\n' "ERROR" "$@"
	exit 1
}

checkperms()
{
if [[ -z ${homedir} ]]; then
homedir=$(pwd) 
fi
if [[ -w ${homedir} ]]; then 
info "Permissions acquired for ${SCRIPT} on ${homedir}."
else 
fatal "InSufficient permissions to run the ${SCRIPT}."
fi
}

checkDomain()
{
info "Initializing Domain ${cn} check ? "
if [[ ! -z ${yourdomain} ]]; then 
workdir=${homedir}/${yourdomain}
echo -e "${cn}"|grep -E -i -q "${yourdomain}$" && echo -n "[OK]" || fatal "InValid domain in ${cn}"
else
workdir=${homedir}/${cn#*.}
echo -n "[NULL]"
info "WARNING: No domain declared to check."
confirmUserAction
fi
}	# end function checkDomain

usage()
{
cat << EOF 

	Usage: 	$SCRIPT [options]
			[-c <common name>] 
			[-h (help)]
			[-x (optional)]

	Command line switches are optional. The following switches are recognized.

	-c	--Sets the value for common name.
		A valid common name is something that ends with 'xyz.com'

	-x 	--Creates the certificate request and key but do not print on screen.
       		To be used when script is used just to create the key and CSR with no need
		+ to generate the certficate on the go. 	

	-h  	--Displays the usage. No further functions are performed.

	Example: $SCRIPT -c mywebsite.xyz.com -m myemail@mydomain.com

EOF
}	# end usage

confirmUserAction() {
while true; do
read -p "Do you wish to continue? ans: " yn
case $yn in
[Yy]* ) info "Initiating the process";
break;;
[Nn]* ) exit 1;;
* ) info "Please answer yes or no.";;
esac
done
}	# end function confirmUserAction

genCSRfile()
{
info "Creating signed key request for ${cn}"

#Generate a key
openssl genrsa -des3 -passout pass:$password -out ${workdir}/${cn}.key 4096 -noout 2>/dev/null && echo -n "[DONE]" || fatal "unable to generate key"

#Create the request
info "Creating Certificate request for ${cn}"
openssl req -new -key ${workdir}/${cn}.key -passin pass:$password -sha1 -nodes \
	-subj "/C=$country/ST=$state/L=$locality/O=${organization}/OU=${organizationalunit}/CN=${cn}/emailAddress=$email" \
	-out ${workdir}/${cn}.csr 2>/dev/null && echo -n "[DONE]" || fatal "unable to create request"

#Remove passphrase from the key. Comment the line out to keep the passphrase
info "Removing passphrase from ${cn}.key"
openssl rsa -in ${workdir}/${cn}.key -passin pass:$password -out ${workdir}/${cn}.insecure 2>/dev/null && echo -n "[DONE]" || fatal "unable to remove passphrase"

#swap the filenames
info "Swapping the ${cn}.key to secure"
mv ${workdir}/${cn}.key ${workdir}/${cn}.secure && echo -n "[DONE]" || fatal "unable to perfom move"
info "Swapping insecure key to ${cn}.key"
mv ${workdir}/${cn}.insecure ${workdir}/${cn}.key && echo -n "[DONE]" || fatal "unable to perform move"
}

printCSR()
{
if [[ -e ${workdir}/${cn}.csr ]] && [[ -e ${workdir}/${cn}.key ]]
then 
echo -e "\n\n----------------------------CSR-----------------------------"
cat ${workdir}/${cn}.csr
echo -e "\n----------------------------KEY-----------------------------"
cat ${workdir}/${cn}.key
echo -e "------------------------------------------------------------\n"
else 
fatal "CSR or KEY generation failed !!"
fi
}

### END Functions ###

#Check the number of arguments. If none are passed, print help and exit.
NUMARGS=$#
if [ $NUMARGS -eq 0 ]; then
fatal "$NUMARGS Arguments provided !!!! See usage with '-h'"
fi

#Organisational details

while getopts ":c:hx" atype
do
case $atype in
c )
	CFOUND=1
	cn="$OPTARG"
	;;
x )
	XFOUND=1
	;;
h )
	usage
	;;
\? )
	usage
	;;
: )
	fatal "Argument required !!! see \'-h\' for help"
	;;
esac
done
shift $(($OPTIND - 1))

#### END CASE #### START MAIN ####

if [ $CFOUND -eq 1 ]
then

# take current dir as homedir by default. 
checkperms ${homedir}
checkDomain

if [[ ! -d ${workdir} ]] 
then
mkdir ${workdir:-${cn#*.}} 2>/dev/null && info "${workdir} created." 
else
info "${workdir} exists."
fi # end workdir check

genCSRfile
if [ $XFOUND -eq 0 ]
then 
sleep 2
printCSR
fi	# end x check
else
	fatal "Nothing to do!"
fi	# end common name check

##### END MAIN #####