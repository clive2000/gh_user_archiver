#!/bin/bash

set -x

print_usage() {
  echo "Archive User's github repo"
  echo "Usage: -u username -k api_token"
}

while getopts 'u:k:' flag; do
  case "${flag}" in
    u) username="${OPTARG}" ;;
    k) token="${OPTARG}" ;;
    v) verbose='true' ;;
    *) print_usage
       exit 1 ;;
  esac
done

if [ -z "$username" ] || [ -z "$token" ] ; then
        echo 'Missing -u -k ' >&2
        print_usage
        exit 1
fi

echo "Fetching $username's repo"
curl -s -H "Authorization: token $token" \
  -H 'Accept: application/vnd.github.v3+json' \
  -L https://api.github.com/user/repos?access_token=$token \
  -o output.json


mapfile -t array <<< $(jq -r '.[] | .full_name ' output.json)

mkdir -p repos
cd repos

for repo in "${array[@]}"
do
  echo $repo
  git clone https://"$token"@github.com/$repo
done

cd ..



