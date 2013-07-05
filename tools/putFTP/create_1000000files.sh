#!/bin/bash

DIR_CURRENT=`pwd`
# Arg1 : FOLDER_INDEX
# Arg2 : FILE COUNT_MAX
createFiles()
{
	local iCnt=0;
	local iIndex=$1
	local iCntMax=$2
	local pFldNAME="FOLDER_${iIndex}_${iCntMax}FILES"
	
	echo "mkdir ${pFldNAME} && cd ${pFldNAME}"
	mkdir ${pFldNAME} && cd ${pFldNAME}
	if test $? -eq 0 ; then
		echo "touch file-${iIndex}-${iCnt}.txt"
		while test ${iCnt} -lt ${iCntMax}
		do
			touch file-${iIndex}-${iCnt}.txt
			iCnt=`expr ${iCnt} + 1`
		done
	fi
}

# Arg 1 : Index Max
# Arg 2 : File Cnt Max
main()
{
	local iCntIndex=0;
	local iCntIndexMax=$1;
	local iCntFileCntMax=$2
	while test ${iCntIndex} -lt ${iCntIndexMax}
	do
		echo "createFiles ${iCntIndex} ${iCntFileCntMax}"
		cd ${DIR_CURRENT}
		createFiles ${iCntIndex} ${iCntFileCntMax}
		iCntIndex=`expr ${iCntIndex} + 1`
	done
}

# create (ARG1 * ARG2) emptyfiles
#
# create 1,000,000 files.
main 1000 1000
