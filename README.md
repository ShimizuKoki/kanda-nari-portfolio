# 神田なり ポートフォリオサイト

取材・コラムライター＆エッセイスト 神田なり（神田佳恵）さんのポートフォリオサイト。
取材はA面、エッセイはB面の二面構成。

- 公開URL: https://nalie-books.netlify.app/
- ホスティング: Netlify。このリポジトリの `main` に push すると自動で反映される（ビルドコマンドなし。`site/` フォルダをそのまま配信）
- いまは **noindex**（検索エンジンに載せない）設定。外し方は下の「noindex の外し方」

## フォルダ構成

```
site/                    Netlify が配信する公開フォルダ。ここ以外（src/ や README）は配信されない
  index.html             サイト本体。1ファイルで完結（画像は data URI で埋め込み済み）。手で編集しない
  .nojekyll              GitHub Pages で公開していた頃の名残。無害なので残している
src/                     編集用のソース。直すのはこちら
  parts/01-head.html     <title> と CSS
  parts/02-hero.html     ナビ・Hero・掲載媒体の帯・選んだ8本・数字
  parts/03-index-a.html  実績の索引（前半：A面＝取材）
  parts/04-index-b.html  実績の索引（後半：B面＝エッセイ）
  parts/05-about.html    About・できることと料金・nalie books・受賞と掲載・寄せられた言葉・お問い合わせ
  parts/06-script.html   JavaScript（タブ切り替え、メールアドレスのコピーなど）
  assets/portrait.jpg    ポートレート
  assets/work-01〜06.jpg 「選んだ8本」のサムネイル
  assets/logos/          掲載媒体のロゴ
  assets/icon/           ファビコン・ホーム画面アイコン
  build.sh               parts/ を結合し、assets/ の画像を埋め込んで src/index.html と src/page.html を作る
  deploy-update.sh       src/index.html に noindex を付けて site/index.html に書き出す
netlify.toml             Netlify の設定（publish = "site"、セキュリティ系ヘッダー）
.gitignore               ビルドの中間生成物（src/index.html、src/page.html）を除外
```

## 更新手順（Mac のターミナルで、このリポジトリのフォルダに入って実行）

1. `src/parts/` の該当ファイルを直す。画像を替えるときは `src/assets/` のファイルを同じ名前で置き換える
2. ビルドする

   ```sh
   sh src/build.sh
   ```

3. 公開用に書き出す（noindex 付き）

   ```sh
   sh src/deploy-update.sh
   ```

4. 手元で確認する

   ```sh
   open site/index.html
   ```

5. コミットして push する

   ```sh
   git add -A
   git commit -m "更新内容をここに"
   git push
   ```

6. 1〜2分で https://nalie-books.netlify.app/ に反映される。進み具合は Netlify の管理画面「Deploys」で見られる

`site/index.html` を直接編集しても、次のビルドで上書きされるので、必ず `src/parts/` を直す。

## noindex の外し方（本人確認が済み、検索エンジンに載せてよくなったら）

```sh
sh src/build.sh
NOINDEX=0 sh src/deploy-update.sh
git add -A
git commit -m "noindex を外して検索エンジンに公開"
git push
```

`site/index.html` から `<meta name="robots" content="noindex, nofollow">` の行が消えていれば成功。

`deploy-update.sh` は既定で noindex を付けるので、以後の更新で `NOINDEX=0` を付け忘れると noindex が戻ってしまう。
恒久的に外すなら `src/deploy-update.sh` の `${NOINDEX:-1}` を `${NOINDEX:-0}` に書き換えておく。

## よくある変更

- **媒体ロゴを文字タイルに戻す**（掲載NGの媒体が出たとき）: `src/parts/02-hero.html` の「掲載媒体」の帯で、該当する
  `<li class="lt" title="…"><img …></li>` を `<li class="lt text">媒体名</li>` に置き換える。
  帯は同じ `<ul>` が2つ（2つ目は `aria-hidden="true"`）並んでいるので、両方を直す
- **ポートレートの差し替え**: `src/assets/portrait.jpg` を置き換えてビルド
- **独自ドメイン**: Netlify 管理画面の Domain management で追加し、DNS の CNAME を `nalie-books.netlify.app` に向ける。HTTPS は自動

## 注意

- 公開リポジトリなので、本人への確認メモ・連絡文・下書きはここに置かない
- 掲載している媒体ロゴと記事画像は各媒体の商標・著作物。掲載可否は本人から各媒体に確認する
