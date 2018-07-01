#!/bin/bash
# AUTHOR: Abhishek Tamrakar
# EMAIL: abhishek.tamrakar08@gmail.com
# VERSION: 1.0.0
# LICENSE: Copyright (C) 2018 Abhishek Tamrakar
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
##
#define variables
GET=$(which egrep)
AWK=$(which awk)
TMUX=$(which tmux)
DOCKER=$(which docker)
COMMAND=''
SCRIPT=${0##*/}
NEWSESSION="${SCRIPT%%.*}$RANDOM"
VERBOSE=0
# define functions
info()
{
  if [ $VERBOSE -eq 1 ]; then
    #statements
    printf '\n%s:%20s\n' "info" "$@"
  fi
}

warn()
{
  if [ $VERBOSE -eq 1 ]; then
    #statements
    printf '\n%s:%20s\n' "warn" "$@"
  fi
}

fatal()
{
  printf '\n%s:%20s\n' "error" "$@"
  exit 1
}

copyright()
{
  printf '\n%s\n%s\n' "VERSION: 1.0.0" "Copyright (C) 2018 Abhishek Tamrakar"
  printf '\n%s\n' "This script is an extension of kube_plugins, visit https://github.com/abhiTamrakar/kube-plugins for more details."
  exit 0
}

usage()
{
  cat <<EOF

  Copyright (C) 2018 Abhishek Tamrakar

  USAGE: $SCRIPT [options] -[hvskldv]

  [options]
  	h|   Display this usage and exit.

  	v|   Enable verbose output.

  	s|   Sets Session name, otherwise defaults to script name.

  	l|   Tails all logfiles inside a directory.

  	d|   Tails all docker running container logs.

	  V|   Prints the version information and exit.

  EXAMPLES:
	# tails all files from a directory
	$SCRIPT -l /path/to/directory

	# tails all runing docker container logs
	$SCRIPT -d

	# print usage
	$SCRIPT -h

	# print version information
	$SCRIPT -V
EOF
  exit 0
}

check_commands()
{
  local EXT=$1
  CMDS=(GET AWK TMUX $EXT)
  for cmd in ${CMDS[@]}
  do
     if [ x${!cmd} = x ]; then
       fatal "${!cmd} not found"
     fi
  done
}

destroy()
{
  $TMUX kill-server 2>/dev/null \
    && info "All sessions killed"
}

check_arguments()
{
  if [[  x$1 = x || $1 =~ ^-[A-Za-z0-9]+ ]]; then
    #statements
    usage
    fatal "Argument is required!"
  fi
}

start_server()
{
  $TMUX start-server \
    || fatal "Failed to start tmux server"
}

check_session()
{
  if $TMUX has-session -t $NEWSESSION 2>/dev/null;
  then
    is_session=0
  else
    is_session=1
  fi
}

create_session()
{
  $TMUX new-session -d -s $NEWSESSION \
    || fatal "Cannot create session"
  $TMUX set-window-option -g automatic-rename off
}

start_split()
{
  check_session
  if [ $is_session -eq 1 ]; then
    # create session
    start_server
    create_session
  fi
  $TMUX selectp -t $n \; \
    splitw $COMMAND \; \
    select-layout tiled \;
}

run_docker_command()
{
  n=0
  CONTAINERS=($(sudo $DOCKER ps| awk '/Up/ {print $1}' ORS=' '))
  for CONTAINER in ${CONTAINERS[@]}
  do
    COMMAND="sudo $DOCKER logs -f $CONTAINER"
    start_split
    ((n+=1))
  done
}

run_tail_command()
{
  n=0
  LOGFILES=($(sudo find ${LOGLOCATION}/ -type f -iname "*.log"| xargs echo))
  for LOG in ${LOGFILES[@]}
  do
    COMMAND="sudo tailf $LOG"
    start_split
    ((n+=1))
  done
}

attach_sessions()
{
  if [ x$NEWSESSION = x ]
  then
    usage
  fi
  $TMUX selectw -t $NEWSESSION:1 \; \
  attach-session -t $NEWSESSION\;
}
#
# interrupt or quit
trap destroy 2 3 15 EXIT
#
while getopts "hvs:k:l:dV" option
do
  case $option in
    h ) usage
      ;;
    v ) VERBOSE=1
      ;;
    s )
      NEWSESSION="$OPTARG"
      check_arguments $NEWSESSION;
      ;;
    l )
      LOGLOCATION="$OPTARG"
      check_arguments $LOGLOCATION
      [ -d $LOGLOCATION -a -s $LOGLOCATION ] || fatal "Log location cannot be found!"
      LOG_FOUND=1
      ;;
    d ) check_commands DOCKER
      DOCKER_FOUND=1
      ;;
    V ) copyright
      ;;
    : ) fatal "argument needed with -$OPTARG" >&2
      ;;
   \? ) fatal "invalid option -$OPTARG" >&2
      ;;
  esac
done
shift $(($OPTIND - 1))
#
#run main
if [ ${LOG_FOUND:-0} -eq 1 ]
then
  run_tail_command
  attach_sessions
elif [ ${DOCKER_FOUND:-0} -eq 1 ]
then
  run_docker_command
  attach_sessions
fi
