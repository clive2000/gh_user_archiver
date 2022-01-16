#!/bin/bash

# Create repo for new users

print_usage() {
  echo "Archive User's github repo"
  echo "Usage: -u username -k api_token"
}

while getopts 'u:k:d:n:' flag; do
  case "${flag}" in
    u) username="${OPTARG}" ;;
    k) token="${OPTARG}" ;;
    d) new_user="${OPTARG}" ;;
    n) new_token="${OPTARG}" ;;
    v) verbose='true' ;;
    *) print_usage
       exit 1 ;;
  esac
done

if [ -z "$username" ] || [ -z "$token" ] || [ -z "$new_token" ] || [ -z "$new_user" ]; then
        echo 'Missing -u -k -d -n ' >&2
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
    if [ -d $repo ];
    then
      cd $repo
      git remote remove origin
      git remote add origin https://$new_token@github.com/$new_user/$repo.git
      git branch -M main
      git push -u origin main
      cd ..
    fi
done


cd ..



