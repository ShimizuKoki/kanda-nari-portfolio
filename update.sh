#!/bin/sh
# 公開用フォルダを最新の index.html から作り直す。
# NOINDEX=0 sh update.sh で noindex を外す（本人確認が済んで検索に載せてよくなったら）。
cd "$(dirname "$0")" || exit 1
cp ../index.html index.html
if [ "${NOINDEX:-1}" = "1" ]; then
  sed -i '' 's|<meta name="viewport"[^>]*>|&\
<meta name="robots" content="noindex, nofollow">|' index.html
fi
touch .nojekyll
grep -c 'name="robots"' index.html >/dev/null && echo "noindex: on" || echo "noindex: off"
wc -c index.html
