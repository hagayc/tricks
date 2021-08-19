#!/bin/bash
# Prerequisites: curl and jq packages installed
 
set -e
echo -n '' > clone-repos.sh
chmod +x clone-repos.sh
 
USER=XXXXXX
PASS=XXXXXXX
PROJECT=XXXXXX 
 
curl -k -s -u "$USER:$PASS" https://XXX.XXX.XXX.XXX:8443/rest/api/1.0/projects/$PROJECT/repos/\?limit=1000\
|jq -r '.values[] | {slug:.slug, links:.links.clone[] } |"git clone \(.links.href)"' \
>> clone-repos.sh
 
# run the generated script
./clone-repos.sh