# Gitbucket, Jenkins, Redmine を使用した CICD の練習用環境

# 構成

### Gitbucket(4.42.1)

- port: 8081

Tomcat(10.1.39-jre21)のイメージに、gitbucket.war(4.42.1)をインストールしたイメージを作成して使用しています。
Gitbucket の[リポジトリ](https://github.com/gitbucket/gitbucket/releases)からダウンロードしたものを、[ここ](./dockerfiles/gitbucket/resources/gitbucket-4.42.1/)に配置してから docker compose でコンテナを起動すると、Tomcat イメージに gitbucket.war が取り込まれたイメージが生成されます。

### Jenkins(lts-jdk17)

- port: 8082

Dockerhub から公式イメージをダウンロードして使用しています。

### Redmine(5.1.7)

- port: 8083

Dockerhub から公式イメージをダウンロードして使用してます。
ただし、公式イメージをそのまま起動しただけだと、デフォルトのロールなどが作成されていません。
そのため実際には、公式イメージに初期化スクリプトを取り込んだイメージを作成して使用しています。

### MySQL(9.2.0)

- port: 非公開(コンテナからのみアクセス可能)

Dockerhub から公式イメージをダウンロードして使用しています。
Redmine のデータベースとして使用しています。

# 使い方

コンテナの起動は

```bash
make start
```

コンテナの停止は

```bash
make stop
```

でそれぞれ行います。

# Redmine の構築について

Redmine の公式イメージをそのまま使用した場合、初期ロールなどのデータが未登録の状態です。
[ドキュメント](https://www.redmine.org/projects/redmine/wiki/RedmineInstall)によると、以下のコマンドを実行することで初期データが登録されるとのことです。

```bash
RAILS_ENV=production REDMINE_LANG=ja bundle exec rake redmine:load_default_data
```

ただし、コンテナ起動後にマニュアルで実行するのはわずわらしいので、
シェルスクリプトを作成して、コンテナの初回起動時に１回だけ自動で実行するようにします。

### スクリプトについて

作成したスクリプトは[init.sh](./dockerfiles/redmine/resources/init.sh)になります。
このスクリプトは、コンテナ起動時に"default_data_loaeded.flag"というファイル(以下、フラグファイルと略)を探して、
ファイルがなければ初期データを登録してフラグファイルを作成します。
２回目以降は、フラグファイルが存在するので、初期データ登録処理はスキップして、Readmine が起動します。

### Dockerfile について

Dockerfile で、Redmine の公式イメージにスクリプトを取り込んで、
最終的にエントリポイントで取り込んだスクリプトを実行するようにしています。

詳細は、スクリプトの[README.md](./dockerfiles/redmine/resources/init.sh)を参照してください。

# リンク

- [Gitgucket のリポジトリ](https://github.com/gitbucket/gitbucket/releases)
- [Tomcat: Docker Hub](https://hub.docker.com/_/tomcat)
- [Jenkins: Docker Hub](https://hub.docker.com/r/jenkins/jenkins)
- [MySQL: Docker Hub](https://hub.docker.com/_/mysql)
- [Redmine: Docker Hub](https://hub.docker.com/_/redmine)
- [Redmine: Install Document](https://www.redmine.org/projects/redmine/wiki/RedmineInstall)
