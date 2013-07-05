FTPSERVER_ADDR=192.168.12.2
USER_NAME=USER_B
USER_PASSWD=USER_B
FTPSERVER_TARGET_DIR=/mnt/disk1/ftp_dst


FTP_CMD_FILENAME=putall.txt
FTP_CMD_PRE_PUT=open $(FTPSERVER_ADDR)\nuser $(USER_NAME) $(USER_PASSWD)\nprompt off\ncd $(FTPSERVER_TARGET_DIR)\n
FTP_CMD_PUT=put
FTP_CMD_POST_PUT=

FTPCMD=ftp -n

############
# put all
############
USAGE_MSG="\n\n\n\n\n\n\
Usage: \n\
make putall : put all Directory and Files in current directory.\n\
\n\
notice:\n\
    * Filename or Dirname must not include space.\n\
        ex. 'sample file.txt' will not be put.\n\
"

############
### Usage
usage:
	echo -e $(USAGE_MSG)

############
### put all local data.
create_FTP_CMD_FILENAME:
	echo -e "$(FTP_CMD_PRE_PUT)" > $(FTP_CMD_FILENAME);\
	\
	for d in `find . -type d`;\
	do \
		echo "mkdir $$d" >> $(FTP_CMD_FILENAME);\
	done;\

	for x in `find . -type f` ;\
	do \
		echo "$(FTP_CMD_PUT) $$x" >> $(FTP_CMD_FILENAME);\
	done; \

	\echo bye >> $(FTP_CMD_FILENAME)

do_putall:
	$(FTPCMD) < $(FTP_CMD_FILENAME)

putall: create_FTP_CMD_FILENAME do_putall

help: usage
all: usage

