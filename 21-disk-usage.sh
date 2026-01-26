#!/bin/bash

DISK_THRESHOLD=1   # set 75 for real project
MSG=""

# Get disk usage, skip header
df -hT | grep -v Filesystem | while read -r line
do
    USAGE=$(echo "$line" | awk '{print $6}' | cut -d "%" -f1)
    PARTITION=$(echo "$line" | awk '{print $7}')

    if [ "$USAGE" -ge "$DISK_THRESHOLD" ]
    then
        LINE="High Disk Usage on $PARTITION: $USAGE%"

        # Print ONLY the current line (no duplication in SSH)
        echo "$LINE"

        #Accumulate message for email
        MSG+="$LINE<br>"
    fi
done

# Send email only once (final accumulated MSG)
if [ -n "$MSG" ]
then
    {
        echo "To: your_email@gmail.com"
        echo "Subject: Disk Usage Alert"
        echo "Content-Type: text/html"
        echo ""
        echo "$MSG"
    } | msmtp your_email@gmail.com
fi
