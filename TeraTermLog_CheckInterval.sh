#!/bin/bash

# This script is working with
# Fedora14
# kernel 2.6.35.14-106.fc14.i686
# GNU bash, version 4.1.7(1)-release (i386-redhat-linux-gnu)
# LANG=C

# main config
DEBUG=0

# WORD config
GREP_WORD="Power down"
PATTERN="[0-9]\{2\}[:][0-9]\{2\}[:][0-9]\{2\}" # Ex. "11:22:33 ...\n"

# range config
RANGE_MIN_MINUTE=20
RANGE_MAX_MINUTE=25

# check args, set options
function argCheck()
{
while [ "$1" != "" ]
do
	case "$1" in
	"-D" ) DEBUG=1 ;;

	# default
	* )    FILENAME="${1}"; export FILENAME ;;
	esac

	shift
done
}

# checking...
#     is file ${FILENAME} exist?
function pre_main()
{
	WORK_FILE="${FILENAME}_grep_date_only"
	export WORK_FILE

	debug "FILENAME is ${FILENAME}!"

	if test "" = "${FILENAME}" ; then
		echo "ERROR: filename is needed."
		echo ""
		echo "Ex. checklog.sh hoge.log"
		exit 1
	fi

	if test -e ${FILENAME} ; then
		:
	else
		echo "ERROR: ${FILENAME} not exist."
		exit 2
	fi

	grep "${GREP_WORD}" > ${FILENAME}_grep_GREP_WORD < ${FILENAME}
	grep -o "${PATTERN}" < ${FILENAME}_grep_GREP_WORD > ${WORK_FILE}
}

# delete temporary files.
function clear_tmpfiles()
{
	TARGET_FILES_TO_CLEAR="${WORK_FILE} ${FILENAME}_grep_GREP_WORD"

	if test 1 -ne ${DEBUG} ; then
		rm ${TARGET_FILES_TO_CLEAR}
	else
		debug ""
		debug "we did not delete '${TARGET_FILES_TO_CLEAR}' for DEBUG."
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

function main()
{
	OLD_HOUR=0
	OLD_MIN=0
	INTERVAL=0
	I_LOOP=0

while read line
do
	debug "=================================================="
	debug "=== loop ${I_LOOP} start"

	if [ "" = "${line}" ] ; then
		break
	fi

	# このフォーマットを元に、ログの 時・分を取得
	# 09:51:44
	# ':' 区切り
	NEW_HOUR=`echo ${line} | awk -F: '{print $1}' | sed 's/^0//'`
	NEW_MIN=`echo ${line} | awk -F: '{print $2}' | sed 's/^0//'`
	NEW_SEC=`echo ${line} | awk -F: '{print $3}' | sed 's/^0//'`

	debug "NEW_HOUR is ${NEW_HOUR}"
	debug "NEW_MIN is ${NEW_MIN}"
	debug "NEW_SEC is ${NEW_SEC}"
	debug "OLD_HOUR is ${OLD_HOUR}"
	debug "OLD_MIN is ${OLD_MIN}"
	debug "OLD_SEC is ${OLD_SEC}"

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
argCheck $* # check args, set options.
pre_main
main
clear_tmpfiles

exit
