# 神田なり ポートフォリオ（公開用）

- `index.html` … サイト本体（1ファイル。画像は埋め込み済み）
- `.nojekyll` … GitHub Pages の Jekyll 処理を無効化
- 更新: 元フォルダで `sh build.sh` → `sh deploy/update.sh` → このフォルダで `git add -A && git commit && git push`
- 検索エンジンに載せる段階になったら `NOINDEX=0 sh update.sh` で noindex を外す
- 独自ドメインを使う場合: このフォルダに `CNAME` ファイル（中身はドメイン名1行）を置き、DNS 側で `CNAME` を `<ユーザー名>.github.io` に向ける
