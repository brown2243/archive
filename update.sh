#!/bin/bash
current_time=$(date "+%Y-%m-%d %H:%M:%S")
git submodule update --remote
submodules=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
commit_message_file="commit_message.txt"
echo "time: $current_time" >"$commit_message_file"

for submodule in $submodules; do
  echo "Checking $submodule..."
  cd "$submodule" || exit
  new_commits=$(git rev-list HEAD..origin/HEAD --count)
  echo "$submodule: $new_commits commits" >>"$commit_message_file"
  cd - >/dev/null || exit
  git add "$submodule"
done

git add .
git commit -F "$commit_message_file"
git push

# 커밋 메시지 파일 삭제
rm -f "$commit_message_file"

# 완료 메시지 출력
echo "Submodule update complete!"
