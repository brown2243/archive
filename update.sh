#!/bin/bash

# 현재 시간 가져오기
current_time=$(date "+%Y-%m-%d %H:%M:%S")
commit_message_file="commit_message.txt"
git submodule update --remote

# 모든 서브모듈 목록 가져오기
submodules=$(git config --file .gitmodules --get-regexp path | awk '{ print $2 }')
# 커밋 메시지를 저장할 변수 초기화
commit_message="time: $current_time"

# 각 서브모듈 변경 여부 체크
for submodule in $submodules; do
  echo "Checking $submodule..."

  # 서브모듈 경로로 이동
  cd "$submodule" || exit
  # 현재 커밋과 최신 커밋 비교 (커밋 수 계산)
  new_commits=$(git rev-list HEAD..origin/HEAD --count)
  # 결과 출력
  commit_message+="\n$submodule: $new_commits commits"
  # 상위 디렉토리로 돌아가기
  cd - >/dev/null || exit
  git add "$submodule"
done

git add .
echo "$commit_message" >>"$commit_message_file"
git commit -F "$commit_message_file"
git push

# 완료 메시지 출력
echo "Submodule update complete!"
# 커밋 메시지 파일 삭제
rm -f "$commit_message_file"
