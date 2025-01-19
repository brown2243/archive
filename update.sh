#!/bin/bash

current_time=$(date "+%Y-%m-%d %H:%M:%S")
commit_message_file="commit_message.txt"
git submodule update --remote

submodules=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')

commit_message="commit time: $current_time"

for submodule in $submodules; do
  echo "Checking $submodule..."
  cd "$submodule" || exit
  new_commits=$(git rev-list HEAD..origin/HEAD --count)
  commit_message+="\n$submodule: $new_commits commits"
  cd - >/dev/null || exit
  git add "$submodule"
done

git add .
printf "%b\n" "$commit_message" >"$commit_message_file"
git commit -F "$commit_message_file"
git push

echo "Submodule update complete!"

rm -f "$commit_message_file"
