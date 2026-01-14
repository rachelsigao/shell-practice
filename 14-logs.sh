#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGS_FOLDER="/var/log/shellscript-logs" 
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

if [ $USERID -ne 0 ]
then
    echo -e "$R ERROR: $N Please run this script with root access" | tee -a $LOG_FILE
    exit 1 #give other than 0 upto 127
else
    echo "You are running with root access, Script is being installed" | tee -a $LOG_FILE
fi

#Validate function takes input as exit status, what command they tried to install
VALIDATE ()
    {
    if [ $1 -eq 0 ]
    then 
        echo -e "Installing $2 is $G SUCCESS $N" | tee -a $LOG_FILE
    else 
        echo -e "Installing $2 is $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
    }

dnf install mysql -y
if [ $? -ne 0 ]
then 
    echo "MySQL is not installed... going to install" | tee -a $LOG_FILE
    dnf install mysql -y
    VALIDATE $? "MySQL"
else
    echo -e "$Y MySQL is already installed $N" | tee -a $LOG_FILE
fi

dnf install python3 -y
if [ $? -ne 0 ]
then 
    echo "python3 is not installed... going to install" | tee -a $LOG_FILE
    dnf install python3 -y
    VALIDATE $? "python3"
else
    echo -e "$Y python3 is already installed $N" | tee -a $LOG_FILE
fi

dnf install nginx -y
if [ $? -ne 0 ]
then 
    echo "nginx is not installed... going to install" | tee -a $LOG_FILE
    dnf install nginx -y 
    VALIDATE $? "nginx"
else
    echo -e "$Y nginx is already installed $N" | tee -a $LOG_FILE
fi