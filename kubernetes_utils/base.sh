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
KUBE=$(which kubectl)
GET=$(which egrep)
AWK=$(which awk)
#

info()
{
printf '\n%s:%20s\n' "info" "$@"
}

fatal()
{
printf '\n%s:%20s\n' "error" "$@"
exit 1
}

checkcmd()
{
local iscmd=$1
if [ ! -e "$iscmd" -a ! -s "$iscmd" ]
then
fatal "$iscmd MISSING"
fi
}

print_table()
{
sep='|'
printf '%s\t%45s\t%17s\n' "POD NAME" "CONTAINER NAME" "NUMBER OF ERROR/EXCEPTION"
printf '%s\n' "---------------------------------------------------------------------------"
printf '%s\n' "$@"| column -s"$sep" -t
printf '%s\n' "---------------------------------------------------------------------------"
}

get_namespaces()
{
namespaces=( \
        $($KUBE get namespaces --ignore-not-found=true | \
        $AWK '/Active/ {print $1}' \
        ORS=" ") \
        )

if [ ${#namespaces[@]} -eq 0 ]
then
  fatal "No namespaces found!!"
fi
}

get_pod_errors()
{
for NAMESPACE in ${namespaces[@]}
do

info "Getting errored pods for Namespace: $NAMESPACE"

while IFS=' ' read -r POD CONTAINERS
do

for CONTAINER in ${CONTAINERS//,/ }
do
STATE=("${STATE[@]}" \
        "$POD|$CONTAINER|$($KUBE logs --since=1h --tail=20 $POD -c $CONTAINER -n $NAMESPACE 2>/dev/null| \
        $GET -ci 'error|exception')" \
        )
done

done< <(kubectl get pods -n $NAMESPACE --ignore-not-found=true -o=custom-columns=NAME:.metadata.name,CONTAINERS:.spec.containers[*].name|sed '1d')

print_table ${STATE[@]}
done
}
