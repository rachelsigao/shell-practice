#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "ERROR: Please run this script with root access"
    exit 1 #give other than 0 upto 127
else
    echo "You are running with root access, Script is being installed"
fi

VALIDATE ()
    {
    if [ $1 -eq 0 ]
    then 
        echo "Installing $2 is SUCCESS"
    else 
        echo "Installing $2 is FAILURE"
        exit 1
    fi
    }

dnf install mysql -y
if [ $? -ne 0 ]
then 
    echo "MySQL is not installed... going to install"
    dnf install mysql -y
    VALIDATE $? "MySQL"
else
    echo "MySQL is already installed"
fi

dnf install python3 -y
if [ $? -ne 0 ]
then 
    echo "python3 is not installed... going to install"
    dnf install python3 -y
    VALIDATE $? "python3"
else
    echo "python3 is already installed"
fi

dnf install nginx -y
if [ $? -ne 0 ]
then 
    echo "nginx is not installed... going to install"
    dnf install nginx -y
    VALIDATE $? "nginx"
else
    echo "nginx is already installed"
fi