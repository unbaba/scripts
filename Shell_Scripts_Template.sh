#!/bin/bash

# this template is tested with
# Fedora14
# kernel 2.6.35.14-106.fc14.i686
# GNU bash, version 4.1.7(1)-release (i386-redhat-linux-gnu)
# LANG=C

# get option from console.
OPTION_INDEX="\
    -D        : ENABLE DEBUG
    --dry-run : Only show command to execute, but don't execute.
    --        : Words after '--' is not considered to be options.
"

# echo arg $1 if $DEBUG is enabled.
function debug()
{
	if test 1 -eq $DEBUG ; then
		echo $1
	fi
} # function debug()

# call this function as this format.
#    getOption $*
function getOption()
{
	# Values for Export.
	DEBUG=0 # DEBUG is enabled ?
	FILENAME=""  # first filename, given from console.
	FILENAMES="" # all filenames given from console.

	# Flags for this function.
	FLAG_NOT_OPTION=""
	
	# How to take --dry-run option?
	#   
	#   ex.)
	#   $ vi Shell_Scripts_Template.sh
	#       ${DRYRUN} ping -c 1 192.168.0.1
	#
	#   $ ./Shell_Scripts_Template.sh
	#   PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
	#   64 bytes from 192.168.0.1: icmp_req=1 ttl=60 time=3.59 ms
	#   
	#   --- 192.168.0.1 ping statistics ---
	#   1 packets transmitted, 1 received, 0% packet loss, time 0ms
	#   rtt min/avg/max/mdev = 3.598/3.598/3.598/0.000 ms
	#
	#   $ ./Shell_Scripts_Template.sh --dry-run
	#	ping -c 1 192.168.0.1
	DRYRUN=""

while [ "$1" != "" ]
do
	case "${FLAG_NOT_OPTION}${1}" in
	'-D' ) DEBUG=1 ;;
	'--' ) FLAG_NOT_OPTION=1 ;;
	'--dry-run' ) DRYRUN="echo " ;;
	# default
	* )	FILENAMES="${FILENAMES} ${1}"
		if [ "" = "${FILENAME}" ] ; then
			FILENAME="${1}"
		fi
	;;
	esac
	shift
done

	# delete first space (=' ')   Ex. " file_a file_b" -> "file_a file_b"
	FILENAMES=`echo ${FILENAMES} | sed 's/^ //'`

	export FILENAME
	export FILENAMES
	export DEBUG
	export DRYRUN
}



#============================================================
#=== for checking template functions
function check_getOption()
{
	debug "DEBUG       is  ${DEBUG}."
	debug "FILENAME    is  ${FILENAME}."
	debug "FILENAMES   is  ${FILENAMES}."
	debug "DRYRUN      is  ${DRYRUN}."
}

getOption $*
check_getOption
:
