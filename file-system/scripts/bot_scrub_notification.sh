#!/bin/bash


TOKEN="Token"
BOTNAME="@cloudbot"
CHATID=ID
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
TEXT="`date`

`/opt/zfs/check_status.sh`
"

curl -s -X POST $URL -d chat_id=$CHATID -d text="$TEXT"
