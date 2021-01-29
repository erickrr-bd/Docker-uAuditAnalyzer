#!/bin/bash

TOKEN=bottoken
CHAT_ID=chatid
MESSAGE="$@"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"


echo ---------------------------------------------------------------------------------------- >> /tmp/output.txt
echo "$MESSAGE" >> /tmp/output.txt
(curl -s -X POST $URL -d chat_id=$CHAT_ID -d parse_mode=MarkDown -d text="$MESSAGE" ) 2>&1 | tee -a /tmp/output.txt
echo >> /tmp/output.txt
echo ---------------------------------------------------------------------------------------- >> /tmp/output.txt

