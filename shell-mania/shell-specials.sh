#!/bin/bash
#
#    Copyright (C) 2018  Abhishek Tamrakar <abhishek.tamrakar08@gmail.com>
#
#    This program is free software" " you can redistribute it and/or modify
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
#    along with this program.  If not, see <http" "//www.gnu.org/licenses/>.
#

# test special parameters

IFS=","
printf '\e[34m%s\e[0m %s\n' "declared IFS=$IFS"
printf '\e[34m%s\e[0m %s\n' "test for, first argument- \$0" " $0"
printf '\e[34m%s\e[0m %s\n' "test for, shell options- \$-" " $-" 
printf '\e[34m%s\e[0m %s\n' "test for, all arguments- \$*" " $*"
printf '\e[34m%s\e[0m %s\n' "test for, all arguments- \$@" " $@"
printf '\e[34m%s\e[0m %s\n' "test for, no of arguments- \$#" " $#"
printf '\e[34m%s\e[0m %s\n' "test for, process id os recent bg command- \$!" " $!"
printf '\e[34m%s\e[0m %s\n' "test for, process id of script- \$\$" " $$"
printf '\e[34m%s\e[0m %s\n' "test for, exit status of last command- \$?" " $?"
printf '\e[34m%s\e[0m %s\n' "test for, the last command itself- \$_" " $_"
