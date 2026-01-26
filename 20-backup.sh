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
LOG_FILE="$LOGS_FOLDER/backup.log"

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
        echo -e "$R ERROR: $N Please run this script with root access" 
        exit 1 #give other than 0 upto 127
    else
        echo "You are running with root access, Script is being installed" 
    fi
} 

mkdir -p $LOGS_FOLDER

#function to display command usage
USAGE() {
    echo -e "$R USAGE: $N sh 20-backup.sh <source-dir> <destination-dir> <days(optional)>"
    exit 1
}

#to check if there are sufficient arguments to run the command
if [ $# -lt 2 ] 
then
    USAGE
fi

#check if source directory exists
if [ ! -d $SOURCE_DIR ]
then
    echo -e "$R Source Directory $SOURCE_DIR does not exist, Please check $N" 
    exit 1
fi

#check if destination directory exists
if [ ! -d $DEST_DIR ]
then
    echo -e "$R $DEST_DIR does not exist, Please check $N" | tee -a $LOG_FILE
    exit 1
fi

dnf install zip -y
VALIDATE $? "Installing zip command"

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +$DAYS) #find files older than specified days

#check if there are files to zip
if [ -n "$FILES" ] 
then
    echo "Log files older than $DAYS days to zip are: $FILES" | tee -a $LOG_FILE

    TIMESTAMP=$(date +%F-%H-%M-%S)
    ZIP_NAME="app-logs-$TIMESTAMP.zip" 
    
    cd "$SOURCE_DIR" || exit 1 #change to source directory, -m = move files into zip (delete originals automatically)
    echo "$FILES" | sed "s|$SOURCE_DIR/||" | zip -@ "$ZIP_NAME" #zipping the files and removing source directory path
    
    #check if zip file is created
    if [ -f $ZIP_NAME ] 
    then
        echo -e "$G Successfully created Zip file $N" | tee -a $LOG_FILE
        
        mv "$ZIP_NAME" "$DEST_DIR/" #move zip file to destination directory
        echo -e "Moving zip file to destination directory is... $G SUCCESS $N"

        while IFS= read -r filepath #delete the files in source directory after zip (zip only creates copy of the files not the files themselves.)
        do
            rm -f "$filepath"
            echo "Deleting file in $SOURCE_DIR: $filepath" | tee -a $LOG_FILE
        done <<< "$FILES"
        
    else
        echo -e "Zip file creation is ... $R FAILURE $N"
        exit 1
    fi
else
    echo -e "No log files found older than $DAYS days ... $Y SKIPPING $N"
fi