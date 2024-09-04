#!/usr/bin/env bash
set -e

if [ "$#" -ne 2 ]; then
	echo 'Usage: ddns.sh <ZONE> <DOMAIN>'
	exit 1
fi

if ! command -v jq &> /dev/null; then
	echo 'Missing "jq"'
	exit 1
fi
if ! command -v curl &> /dev/null; then
	echo 'Missing "curl"'
	exit 1
fi

if [[ ! -f '.cf' ]]; then
	echo 'Missing file: ".cf"'
	exit 1
fi

zone=$1
domain=$2
key=$(cat '.cf')

# echo 'Getting IP...'

current_ip=`ip -brief -json -6 addr show scope global -deprecated | jq -e --raw-output '.[0].addr_info | map(select(has("local")))[0].local'`

# echo 'Getting DNS entry...'

result=`curl -s --request GET \
  --url "https://api.cloudflare.com/client/v4/zones/${zone}/dns_records?type=AAAA&name=${domain}" \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer ${key}" \
  | jq -e '.result[0]'`

id=`echo $result | jq --raw-output '.id'`
content=`echo $result | jq --raw-output '.content'`

shopt -s nocasematch
if [[ $current_ip != $content ]]; then
	result=`curl --request PATCH \
	  --url "https://api.cloudflare.com/client/v4/zones/${zone}/dns_records/${id}" \
	  --header 'Content-Type: application/json' \
	  --header "Authorization: Bearer ${key}" \
	  --data '{
	  "content": "'"$current_ip"'",
	  "comment": "Set by ddns.sh",
	  "tags": []
	}'`
	success=`echo $result | jq '.success'`
	if [[ $success == 'true' ]]; then
		echo "Updated IP to: ${current_ip}"
	else
		echo 'Error:'
		echo $result
	fi
else
	echo 'All good.'
fi
