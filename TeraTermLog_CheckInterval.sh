#!/bin/bash

# This script is working with
# Fedora14
# kernel 2.6.35.14-106.fc14.i686
# GNU bash, version 4.1.7(1)-release (i386-redhat-linux-gnu)
# LANG=C

# main config
FILENAME=${1}
DEBUG=0

# WORD config
GREP_WORD="Power down"
PATTERN="[0-9]\{2\}[:][0-9]\{2\}[:][0-9]\{2\}" # Ex. "11:22:33 ...\n"

# range config
RANGE_MIN_MINUTE=20
RANGE_MAX_MINUTE=25


# checking...
#     is file ${FILENAME} exist?
WORK_FILE="${FILENAME}_grep_date_only"
function pre_main()
{
	if test "" = "${FILENAME}" ; then
		echo "ERROR: filename is needed."
		echo ""
		echo "Ex. checklog.sh hoge.log"
		exit 1
	fi

	if test -e $1 ; then
		:
	else
		echo "ERROR: ${FILENAME} not exist."
		exit 2
	fi

	grep "${GREP_WORD}" > ${FILENAME}_grep_GREP_WORD < ${FILENAME}
	grep -o "${PATTERN}" < ${FILENAME}_grep_GREP_WORD > ${WORK_FILE}
}

# delete temporary files.
TARGET_FILES_TO_CLEAR="${WORK_FILE} ${FILENAME}_grep_GREP_WORD"
function clear_tmpfiles()
{
	if test 1 -ne ${DEBUG} ; then
		rm ${TARGET_FILES_TO_CLEAR}
	fi
} # function clear_tmpfiles()

# judge RANGE_MIN_MINUTE <= $1 <= RANGE_MAX_MINUTE ?
# return
# 	0 : false
#	1 : true
function inrange()
{
I_RET=0
	if test ${RANGE_MIN_MINUTE} -le $1 ; then
		if test $1 -le ${RANGE_MAX_MINUTE} ; then
			I_RET=1
		fi
	fi

	echo ${I_RET}
	return ${I_RET}
} # function inrange()

function debug()
{
	if test 1 -eq $DEBUG ; then
		echo $1
	fi
} # function debug()

OLD_HOUR=0
OLD_MIN=0
INTERVAL=0
function main()
{
I_LOOP=0
while read line
do
	debug "=================================================="
	debug "=== loop ${I_LOOP} start"

	if [ "" = "${line}" ] ; then
		break
	fi

	NEW_HOUR=`echo ${line} | awk -F: '{print $1}' | sed 's/^0//'`
	NEW_MIN=`echo ${line} | awk -F: '{print $2}' | sed 's/^0//'`

	debug "NEW_HOUR is ${NEW_HOUR}"
	debug "NEW_MIN is ${NEW_MIN}"
	debug "OLD_HOUR is ${OLD_HOUR}"
	debug "OLD_MIN is ${OLD_MIN}"

	HOUR_INTERVAL=`expr ${NEW_HOUR} - ${OLD_HOUR}`
	debug "HOUR_INTERVAL is ${HOUR_INTERVAL}"

	if test ${HOUR_INTERVAL} -lt 0 ; then
		HOUR_INTERVAL=`expr ${HOUR_INTERVAL} + 24`
		debug "re: expr ${HOUR_INTERVAL} + 60, HOUR_INTERVAL is ${HOUR_INTERVAL}"
	fi

	INTERVAL=`expr ${HOUR_INTERVAL} \* 60 + ${INTERVAL}`

	INTERVAL=`expr ${NEW_MIN} - ${OLD_MIN} + ${INTERVAL}`
	debug "INTERVAL is ${INTERVAL}"

	if [ 0 -eq ${I_LOOP} ] ; then
		echo "start ${NEW_HOUR}:${NEW_MIN}."
	elif test `inrange ${INTERVAL}` -eq 1 ; then
		echo "${OLD_HOUR}:${OLD_MIN}	to	${NEW_HOUR}:${NEW_MIN},	INTERVAL is ${INTERVAL} min, OK."
	else
		echo "!${OLD_HOUR}:${OLD_MIN}	to	${NEW_HOUR}:${NEW_MIN},	INTERVAL is ${INTERVAL} min, NG!!"
	fi

	debug "=== loop ${I_LOOP} end"
	debug "=================================================="

	# prepare to next loop.
	OLD_HOUR=${NEW_HOUR}
	OLD_MIN=${NEW_MIN}
	NEW_HOUR=0
	NEW_MIN=0
	INTERVAL=0
	I_LOOP=`expr ${I_LOOP} + 1`

done < ${WORK_FILE}
} # function main()

#===================================================
# main
#===================================================
pre_main # check args
main
clear_tmpfiles
exit
