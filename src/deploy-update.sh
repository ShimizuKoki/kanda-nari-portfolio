#!/bin/sh
# 公開フォルダ site/ を、最新のビルド結果 src/index.html から作り直す。
# 先に sh src/build.sh を実行しておくこと。どのフォルダから実行してもよい。
# 既定では noindex（検索エンジンに載せない）を付ける。
# 本人確認が済んで検索に載せてよくなったら NOINDEX=0 sh src/deploy-update.sh で外す。
cd "$(dirname "$0")/.." || exit 1
if [ ! -f src/index.html ]; then
  echo "src/index.html がありません。先に sh src/build.sh を実行してください。" >&2
  exit 1
fi
mkdir -p site
cp src/index.html site/index.html
if [ "${NOINDEX:-1}" = "1" ]; then
  sed -i '' 's|<meta name="viewport"[^>]*>|&\
<meta name="robots" content="noindex, nofollow">|' site/index.html
fi
grep -q 'name="robots"' site/index.html && echo "noindex: on" || echo "noindex: off"
wc -c site/index.html
