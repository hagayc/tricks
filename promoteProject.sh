#!/bin/bash
### Example: #./promoteProject.sh -s development -d qa -p [PROJECT] -u [USERNAME] -c [PASSWORD]
 
while getopts :s:d:p:u:c: opt
do
  case ${opt} in
     s) src=${OPTARG}
     ;;
     d) dst=${OPTARG}
     ;;
     p) project=${OPTARG}
     ;;
     u) username=${OPTARG}
     ;;
     c) cred=${OPTARG}
     ;;
     \? ) echo "Usage: ./promoteProject.sh [-s] sourceBranch [-d] destinationBranch [-p] project [-u] username [-c] password"
     ;;
  esac
done
 
IFS=$'\n'
repo=($(curl -k -u $username:$cred \
       'https://192.168.10.10:8443/rest/api/latest/projects/'"$project"'/repos/?pagelen=100&page=1&fields=values.full_name' \
       | jq . | grep slug |awk '{print $2}'| sed 's/".$//; s/^.//'))
 
 
for i in "${repo[@]}"
do
curl -v -k 'https://192.168.10.10:8443/rest/api/latest/projects/'"$project"'/repos/'"$i"'/pull-requests' \
    -u $username:$cred \
    --request POST \
    --header 'Content-Type: application/json' --data '{
               "title": "OPEN PR '"$src"' to '"$dst"'",
               "description": "Fast Promotion '"$src"' to '"$dest"'",
               "fromRef": {
               "id": "refs/heads/'"$src"'"
               },
               "toRef": {
               "id": "refs/heads/'"$dst"'"
               }
             }'
done
