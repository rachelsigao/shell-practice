#!/bin/bash

echo "All variables passed to the script: $@"
echo "Number of variables: $#"
echo "script name: $0"
echo "Current directory: $PWD"
echo "User running this script: $USER"
echo "Home directory of the user: $HOME"
echo "PID of the script: $$"
sleep 10 &
echo "PID of the last command in the background: $!"