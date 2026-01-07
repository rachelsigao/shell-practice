#!/bin/bash

Number1=100
Number2=200

Timestamp=$(date)
echo "Script executed at: $Timestamp" 

SUM=$(($Number1+$Number2))
echo "Sum of $Number1 and $Number2 is $Sum"