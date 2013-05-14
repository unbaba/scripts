#!/bin/bash

# this template is tested with 　
# Fedora14
# kernel 2.6.35.14-106.fc14.i686
# GNU bash, version 4.1.7(1)-release (i386-redhat-linux-gnu)
# LANG=C

# get option from console.
OPTION_INDEX="\
    -D : ENABLE DEBUG

    -- : Words after '--' is not considered to be options.
"

function getOption()
{
	# Values for Export.
	DEBUG=0 # DEBUG is enabled ?
	FILENAME=""  # first filename, given from console.
	FILENAMES="" # all filenames given from console.

	# Flags for this function.
	FLAG_NOT_OPTION=""

while [ "$1" != "" ]
do
	case "${FLAG_NOT_OPTION}${1}" in
	'-D' ) DEBUG=1 ;;
	'--' ) FLAG_NOT_OPTION=1 ;;

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
}



#============================================================
#=== for checking template functions
function check_getOption()
{
	echo "DEBUG       is  ${DEBUG}."
	echo "FILENAME    is  ${FILENAME}."
	echo "FILENAMES   is  ${FILENAMES}."
}

getOption $*
check_getOption
:
