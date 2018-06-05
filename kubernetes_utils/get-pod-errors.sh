#!/bin/bash
# AUTHOR: Abhishek Tamrakar
# EMAIL: abhishek.tamrakar08@gmail.com
# LICENSE: This program is free software: you can redistribute it and/or modify
#          it under the terms of the GNU General Public License as published by
#          the Free Software Foundation, either version 3 of the License, or
#          (at your option) any later version.
#
#          This program is distributed in the hope that it will be useful,
#          but WITHOUT ANY WARRANTY; without even the implied warranty of
#          MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#          GNU General Public License for more details.
#
#          You should have received a copy of the GNU General Public License
#          along with this program. If not, see <http://www.gnu.org/licenses/>.
#
# Copyright (C) 2018 Abhishek Tamrakar
#
KUBE_LOC=~/.kube/config
if [ -e ./base.sh -a -s ./base.sh ]
then
. ./base.sh
else
fatal "failed to initialize"
fi
#
usage()
{
cat < EOF

  USAGE: "${0##*/} </path/to/kube-config>"
  
  This program is a free software under the terms of GNU GPL 3.0 License.
  COPYRIGHT (C) 2018 Abhishek Tamrakar

EOF
exit 0
}

for cmd in $KUBE $GET $AWK;
do
checkcmd $cmd
done
#

if [ $# -lt 1 ]; then
        if [ -e ${KUBE_LOC} -a -s ${KUBE_LOC} ]
        then
                export KUBECONFIG=${KUBE_LOC}
        else
                info "A readable kube config location is required!!"
                read -p 'kube-config-location?' KUBE_LOC
                export KUBECONFIG=${KUBE_LOC}
        fi
elif [ $# -eq 1 ]
then
export KUBECONFIG=$1
elif [ $# -gt 1 ]
then
usage
fi
get_namespaces
get_pod_errors
