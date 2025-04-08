# 初期化スクリプトについて

Redmine に初期データを登録するためのコマンドを、
コンテナの初回起動時に一度だけ実行するようなスクリプトを作成します。

# フラグファイルによる初回起動判定

登録処理を実行済みかどうかを、フラグファイルを作成することで判定します。
初回起動時ではファイルが存在しないため、登録処理を実行後ファイルを作成します。
２回目以降の起動時には、ファイルが存在するため、登録処理はスキップされます。

具体的には、コードの以下の部分で行なっています。

```bash
flag_path='/usr/src/redmine/files/default_data_loaded.flag'
if [ -f ${flag_path} ]; then
	# なにもしない
else
	# 初期データを登録して、ファイルを作成する
fi
```

# 初期データ登録作業

初期データを登録するには以下のコマンドを実行します。

```bash
RAILS_ENV=production REDMINE_LANG=ja bundle exec rake redmine:load_default_data
```

ただし、コマンドを実行するには"database.yml"という設定ファイルが必要なので、そのままでは実行できません。
この設定ファイルは、本来のエントリポイント(/docker-entorypoint.sh)の実行時に作成されるため、
コマンドの実行前に docker-entorpoint.sh を実行する必要があります。

[docker-entorypoint.sh](https://github.com/docker-library/redmine/blob/eee88520aa10c29d0aa0ae70b665a7d337387be5/5.1/bookworm/docker-entrypoint.sh)の中をみると、
オプションで"rails"を与えた時に設定ファイルを作成していることがわかります。
また、最後の部分(exec "$@")でオプションで指定した内容(rails xxxx)を実行していることがわかります。
従って、オプションとして 「rails runner ''」を与えることで、設定ファイルの作成と DB のマイグレーションだけをして、
それ以外は何もしないようにします。

具体的なコードは以下の部分です。

```bash
/docker-entrypoint.sh rails runner ""
RAILS_ENV=production REDMINE_LANG=ja bundle exec rake redmine:load_default_data
```

### 注意

上記のコマンドを以下のように exec を使用して行うと、docker-entorypoint.sh が終了した時点でプロセスが終了するため、コンテナが停止してしまいます。

```bash
exec /docker-entrypoint.sh rails runner "" # execはつけてはいけない
```

# Redmine 起動

最後に Redmine を起動するために、
公式イメージのエントリーポイントで実行されているコマンドを実行して、
Redmine を起動します。

具体的なコードは以下の部分です。

```bash
exec /docker-entrypoint.sh rails server -b 0.0.0.0
```
