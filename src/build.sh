#!/bin/sh
# 分割ファイル src/parts/01〜06 を結合し、画像（src/assets/）を data URI で埋め込んで次の2つを作る。
#   src/index.html = そのままホスティングできる完全なHTML（中間生成物。.gitignore で除外）
#   src/page.html  = claude.ai Artifact 用の断片（<title> と <style> から始まる。同じく中間生成物）
# 公開用の site/index.html は、続けて sh src/deploy-update.sh で作る。どのフォルダから実行してもよい。
cd "$(dirname "$0")" || exit 1
cat parts/01-head.html parts/02-hero.html parts/03-index-a.html parts/04-index-b.html parts/05-about.html parts/06-script.html > page.html
{
  printf '%s\n' '<!doctype html>' '<html lang="ja">' '<head>' '<meta charset="utf-8">' \
    '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">' \
    '<meta name="description" content="取材・コラムライター＆エッセイスト 神田なり（神田佳恵）のポートフォリオ。取材はA面、エッセイはB面。">' \
    '<style>:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}[hidden]{display:none!important}</style>' \
    "<link rel=\"icon\" type=\"image/png\" sizes=\"32x32\" href=\"data:image/png;base64,$(base64 < assets/icon/favicon-32.png | tr -d '\n')\">" \
    "<link rel=\"icon\" type=\"image/png\" sizes=\"64x64\" href=\"data:image/png;base64,$(base64 < assets/icon/favicon-64.png | tr -d '\n')\">" \
    "<link rel=\"apple-touch-icon\" sizes=\"180x180\" href=\"data:image/png;base64,$(base64 < assets/icon/apple-touch-icon.png | tr -d '\n')\">"
  sed -n '1,/^<\/style>$/p' page.html
  echo '</head>'
  echo '<body>'
  sed '1,/^<\/style>$/d' page.html
  echo '</body>'
  echo '</html>'
} > index.html
# 写真を data URI として埋め込む（page.html / index.html を1ファイルで配布できるようにする）
python3 -I - <<'PY'
import base64,re,os
MIME={'jpg':'image/jpeg','jpeg':'image/jpeg','png':'image/png','svg':'image/svg+xml','webp':'image/webp'}
def inline(m):
    path=m.group(1)
    if not os.path.exists(path): return m.group(0)
    ext=path.rsplit('.',1)[-1].lower()
    b=base64.b64encode(open(path,'rb').read()).decode('ascii')
    return 'src="data:'+MIME.get(ext,'application/octet-stream')+';base64,'+b+'"'
for f in ('page.html','index.html'):
    s=open(f,encoding='utf-8').read()
    s=re.sub(r'src="(assets/[^"]+\.(?:jpg|jpeg|png|svg|webp))"',inline,s)
    open(f,'w',encoding='utf-8').write(s)
PY
wc -c page.html index.html
