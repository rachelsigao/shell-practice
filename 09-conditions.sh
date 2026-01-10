#!/bin/bash

Number=$1

# -gt --> greater than
# -lt --> less than
# -eq --> equal
# -ne --> not equal


if [ $Number -lt 10 ]
then
    echo "Given number $Number is less than 10"
else
    echo "Given number $Number is greater than 10"
    fi