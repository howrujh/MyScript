#!/usr/bin/python

import pexpect
import datetime
import glob
import re
import os
import sys
import tarfile
import logging
import logging.handlers
import subprocess

#JIRA_ATTACH_SRC_PATH="/var/atlassian/application-data/jira/data/attachments/"
#JIRA_XML_SRC_PATH="/var/atlassian/application-data/jira/export/"
#JIRA_BACKUP_PATH="/var/atlassian/application-data/jira/backups/"

JIRA_ATTACH_SRC_PATH= r"/home/jinhwan/tmp/cron_test/files/"
JIRA_BACKUP_PATH= r"/home/jinhwan/tmp/cron_test/backup/"
JIRA_BACKUP_FILE_PREFIX= r"backup-attachments-"
LOG_PATH=JIRA_ATTACH_SRC_PATH

GDRIVE_BIN="/home/jinhwan/local/bin/drive-linux-amd64"
GDRIVE_BACKUP_DIR_ID= "0B3oOk54VqSD3fktQSXFlcXd3RnV6bVFoaGh1dktaeDBNZzZQYU5VbkR5Z2t4N0ZNRmFwUWc"
GDRIVE_EXPIRATION_DATE= 30

HDD_EXPIRATION_DATE= 30

INVALID_FILE_NAME= "null"
INVALID_FILE_DATE= -9999


# generating backup file name with current date
def make_attach_file_name():
        return JIRA_BACKUP_FILE_PREFIX + datetime.datetime.now().strftime("%Y-%m-%d") + r".tar.gz"

# make tar.gz file from target attachments.
def make_attach_backup_file(file):
        try:
                tf = tarfile.open(file, "w:gz")
                tf.add(JIRA_ATTACH_SRC_PATH, os.path.basename(JIRA_ATTACH_SRC_PATH))
                tf.close()
                return True
        except:
                logger.error("fail to make backup file: "+filename)
                return False


# get elapsed days from input date(parmeter)
def get_elapsed_days(sdate): # input:YYYYMMDD
	e = datetime.datetime.now()
	if not sdate or len(sdate) < 8: 
                logger.error("invalid parameter format :" + sdate)
                return INVALID_FILE_DATE
	try:
		s = datetime.datetime(int(sdate[:4]), int(sdate[4:6]), int(sdate[6:8]))
		days = (e-s).days
		return days
	except:
                logger.error("invalid file's date :" + sdate)
		return INVALID_FILE_DATE


def get_yyyymmdd_format_from_filename(filename):

	date =re.search( JIRA_BACKUP_FILE_PREFIX + r'(.*?)-(.*?)-(.*?).tar.gz', filename)
        
        if date:
                year  = date.group(1)
                month = date.group(2)
                day   = date.group(3)
                return year+month+day
        else:
                return INVALID_FILE_NAME
        

def gdrive_upload_to_backup_dir(file):
        p = subprocess.Popen([GDRIVE_BIN, "upload", "-f", file, "-p", GDRIVE_BACKUP_DIR_ID ], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
   
        while True:
                line = p.stdout.readline()
                if not line:
                        break
 
                match = re.search('[Ee]rror|[Ww]arning|[Ff]ail', line)
                if match:
                        logger.error(line)
                        return False

        logger.info("upload file to gdrive: " + file)
        return True


def gdrive_remove_file_by_id(file_id):
        p = subprocess.Popen([GDRIVE_BIN, "delete", "-i", file_id], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        while True:
                line = p.stdout.readline()
                if not line:
                        break
 
                match = re.search('[Ee]rror|[Ww]arning|[Ff]ail', line)
                if match:
                        return False

        return True




def gdrive_remove_files_expired(expiration_date):
        query_msg = "\"" + GDRIVE_BACKUP_DIR_ID + "\" in parents"
        p = subprocess.Popen([GDRIVE_BIN, "list", "-n", "-q", "\"0B3oOk54VqSD3fktQSXFlcXd3RnV6bVFoaGh1dktaeDBNZzZQYU5VbkR5Z2t4N0ZNRmFwUWc\" in parents"], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

        while True:
                line = p.stdout.readline()
                if not line:
                        break

                match = re.search('(.+?)[\s\t]+(.+?)[\s\t]+', line)
                
                if not match:
                        continue

                file_id = match.group(1)
                file_title = match.group(2)

                yyyymmdd = get_yyyymmdd_format_from_filename(file_title)
                if yyyymmdd == "null":
                        continue
                
                file_age = get_elapsed_days(yyyymmdd)
                
                if file_age > expiration_date:
                        if gdrive_remove_file_by_id(file_id) == True:
                                logger.info("remove file expired from gdrive: " + file_title)
                        else:
                                logger.error("fail to remove file from gdrive: " + file_title)




# --------------<start from here>-------------


# logging init
if not os.path.isdir(LOG_PATH):
        os.mkdir(LOG_PATH)

logger = logging.getLogger('jira_attach_backup_logger')
fomatter = logging.Formatter('[%(levelname)s|%(filename)s:%(lineno)s] %(asctime)s > %(message)s')

fileHandler = logging.FileHandler(LOG_PATH + r"jira_attachments_backup.log")
streamHandler = logging.StreamHandler()
fileHandler.setFormatter(fomatter)
streamHandler.setFormatter(fomatter)

logger.addHandler(fileHandler)
logger.addHandler(streamHandler)
logger.setLevel(logging.DEBUG)


# make backup file name
latest_file  = JIRA_BACKUP_PATH + make_attach_file_name()

# make backup file name
if not os.path.isdir(JIRA_BACKUP_PATH):
        os.mkdir(JIRA_BACKUP_PATH)

print "make attachments backup file..."
if make_attach_backup_file(latest_file) == False:
        logger.error(r"fail to make attachments backup file(" + latest_file + ")")
        latest_file="null"


# check gdrive is exist (google drive cli)
use_gdrive= os.path.exists(GDRIVE_BIN)

if use_gdrive == True:
        # send latest backup file to Google Drive
        print "upload backup file to google drive..."

        if latest_file != "null" and gdrive_upload_to_backup_dir(latest_file) == False:
                #TODO: send message to administrator by email or telegram(cli)
                print "upload false"

        # remove expired backup file from Google Driver
        if gdrive_remove_files_expired(GDRIVE_EXPIRATION_DATE) == False:
                #TODO: send message to administrator by email or telegram(cli)
                print "remove false"
else:
        logger.warning(r"can not find gdrive")




# remove expired backup files from hard disk
attach_files= glob.glob(JIRA_BACKUP_PATH + JIRA_BACKUP_FILE_PREFIX + r"20??-??-??.tar.gz")

for file in attach_files:

        yyyymmdd = get_yyyymmdd_format_from_filename(file)
	file_age = get_elapsed_days(yyyymmdd)

        if file_age == INVALID_FILE_DATE:
                logger.warning(r"invalid date on file name: " + file)
                continue
        elif file_age > HDD_EXPIRATION_DATE:
                logger.info(r"remove expired file from hdd: " + file)
                os.remove(file)
