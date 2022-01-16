#!/bin/bash

# Create repo for new users

print_usage() {
  echo "Archive User's github repo"
  echo "Usage: -u username -k api_token"
}

while getopts 'u:k:n:' flag; do
  case "${flag}" in
    u) username="${OPTARG}" ;;
    k) token="${OPTARG}" ;;
    n) new_token="${OPTARG}" ;;
    v) verbose='true' ;;
    *) print_usage
       exit 1 ;;
  esac
done

if [ -z "$username" ] || [ -z "$token" ] || [ -z "$new_token" ] ; then
        echo 'Missing -u -k ' >&2
        print_usage
        exit 1
fi

echo "Fetching $username's repo"
curl -s -H "Authorization: token $token" \
  -H 'Accept: application/vnd.github.v3+json' \
  -L https://api.github.com/user/repos?access_token=$token \
  -o output.json


mapfile -t array <<< $(jq -r '.[] | .name ' output.json)

mkdir -p repos
cd repos

for repo in "${array[@]}"
do
echo $repo
# curl --request POST \
# --url https://api.github.com/user/repos \
# --header "Authorization: token $new_token" \
# --header 'Content-Type: application/json' \
# --header 'accept: application/vnd.github.v3+json' \
# --data @<(cat <<EOF
# {
# "name": "$repo",
# "private: "true"
# }
# EOF
# )
done


cd ..



