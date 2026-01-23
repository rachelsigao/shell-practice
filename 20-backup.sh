#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14} #If days are provided that will be considered, otherwise default 14 days

LOGS_FOLDER="/var/log/shellscript-logs" 
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

#Validate function takes input as exit status, what command they tried to install
VALIDATE ()
    {
    if [ $1 -eq 0 ]
    then 
        echo -e "$2 is $G SUCCESS $N" | tee -a $LOG_FILE
    else 
        echo -e "$2 is $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
    }


#check for root access
check_root() {
    if [ $USERID -ne 0 ]
    then
        echo -e "$R ERROR: $N Please run this script with root access" | tee -a $LOG_FILE
        exit 1 #give other than 0 upto 127
    else
        echo "You are running with root access, Script is being installed" | tee -a $LOG_FILE
    fi
} 

mkdir -p $LOGS_FOLDER

#function to display command usage
USAGE() {
    echo -e "$R USAGE: $N sh 20-backup.sh <source-dir> <destination-dir> <days(optional)>"
}

#to check if there are sufficient arguments to run the command
if [ $# -lt 2 ] 
then
    USAGE
fi

#check if source directory exists
if [ ! -d $SOURCE_DIR ]
then
    echo -e "$R Source Directory $SOURCE_DIR does not exist, Please check $N" | tee -a $LOG_FILE
    exit 1
fi

#check if destination directory exists
if [ ! -d $DEST_DIR ]
then
    echo -e "$R $DEST_DIR does not exist, Please check $N" | tee -a $LOG_FILE
    exit 1
fi

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +$DAYS)

#zip only when there are files
if [ ! -z $FILES ]
then
    echo "Files older than $DAYS days and ready to zip are: $FILES" | tee -a $LOG_FILE
else
    echo -e "No files older than $DAYS days found in Source Directory $Y Skipping $N" | tee -a $LOG_FILE
fi
