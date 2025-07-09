#!/usr/bin/env bash

# Open PR link
remote_origin_url="$(git config --get remote.origin.url)"

OLD_IFS=$IFS
IFS='/'
read -a remote_origin_parts <<<"${remote_origin_url}"
IFS=$OLD_IFS

azure_owner="${remote_origin_parts[1]}"
azure_project="${remote_origin_parts[2]}"
azure_repo="${remote_origin_parts[3]}"

log --trace "Opening browser to Pull Request URL"
open "https://dev.azure.com/${azure_owner}/${azure_project}/_git/${azure_repo}/pullrequests"
