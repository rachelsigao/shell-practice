#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "ERROR: Please run this script with root access"
    exit 1 #give other than 0 upto 127
else
    echo "You are running with root access, Script is being installed"
fi

dnf install mysql -y

if [ $? -ne 0 ]
then 
    echo "MySQL is not installed... going to install"
    # dnf install mysql -y

# if [ $? -eq 0 ]
# then 
#     echo "Installing MySQL is SUCCESS"
# else 
#     echo "Installing MySQL is FAILURE"
#     exit 1
#     fi
else
    echo "MySQL is already installed"
fi

# dnf install mysql -y

# if [ $? -eq 0 ]
# then 
#     echo "Installing MySQL is SUCCESS"
# else 
#     echo "Installing MySQL is FAILURE"
#     exit 1
#     fi