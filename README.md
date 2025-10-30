# Spring Boot 課題

環境構築はDockerを利用して行います。
ローカル環境でDockerを使えるように整った上、Readmeに沿って課題に進んでください。

```bash
git clone git@github.com:lumiflare/spring-boot-assignment.git
# or
git clone https://github.com/lumiflare/spring-boot-assignment.git

cd spring-boot-assignment
```

## プロジェクト概要
Spring Boot(3.5.x) と MyBatis を用いてシンプルな Post API を実装する課題です。
候補者は API の作成に加え、レスポンスの共通フォーマット化を行います。

## 技術スタック
- Java 17 (Temurin)
- Spring Boot 3.5.x
- MyBatis Spring Boot Starter 3.0.x
- MySQL 8.0
- Gradle 8.x (Wrapper 付属)

## ディレクトリ概要
- `src/main/java` — アプリケーションコード
- `src/main/resources/application-*.properties` — プロファイル別設定
- `src/main/resources/db/mysql/post-schema.sql` — 初期テーブル作成用スクリプト
- `src/main/resources/mappers/` — MyBatis Mapper XML 配置場所
- `docker-compose.yml` & `Dockerfile` — Docker 実行用定義

## セットアップ

```bash
# コードを修正するたびにビルドをする必要があります。
docker-compose build

# バックグラウンド起動
docker-compose up -d

# 停止
docker-compose down
```

## Mysql接続・テーブル作成

```bash
docker-compose exec mysql bash

mysql -h localhost -u post_user -p
# パスワード入力 : post_password

use postdb;

# /src/main/resources/db/mysql/post-schema.sql
CREATE TABLE IF NOT EXISTS post (
    post_id BIGINT NOT NULL AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (post_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

```


## 課題

## 1. 要件（必須）

### 1.1 技術制約

- Readmeの内容に沿って環境構築を行ってください。

### 1.2 ドメイン概要

- **Post（投稿）**: タイトルを持つ掲示板の投稿。

### 1.3 必須機能

1. **投稿一覧取得（ページング）**
2. **エラー応答の標準化**
2.1 ErrorResponse・SuccessListResponseオブジェクトを作成してください。
Errorの場合、ErrorResponseを、Successの場合SuccessListResponseを返すようにAPIを作成してください。


## 2. データモデル

### 2.1 Post

- `id: Long (PK)`
- `title: String`（必須, 1~200）
- `createdAt: Instant`

## 3. API 仕様

### 3.1 エラー共通形式（JSON）

```json
{
  "status": 404,
  "message": "Not Found",
  "field_errors": {}
}
```

```json
{
  "status": 400,
  "message": "Invalid request",
  "field_errors": {
    "title": ["must not be blank"],
  }
}
```

### 3.2 エンドポイント

### 投稿一覧（ページング）

- `GET /api/posts?page=1`
- Response `200 OK`

```json
{
  "posts": [
    { "id": 1, "title": "初めての投稿", "createdAt": "2025-10-24T12:00:00Z" },
    { "id": 2, "title": "2番目の投稿", "createdAt": "2025-10-24T12:00:00Z" },
    { "id": 3, "title": "3番目の投稿", "createdAt": "2025-10-24T12:00:00Z" },
    { "id": 4, "title": "4番目の投稿", "createdAt": "2025-10-24T12:00:00Z" },
    { "id": 5, "title": "5番目の投稿", "createdAt": "2025-10-24T12:20:00Z" }
  ],
  "page": 1,
  "size": 5,
  "totalElements": 7,
  "totalPages": 2
}
```

- 投稿一覧を取得できるAPIを作成してください。
- ダミーデータの作成はご自由にお願いします。
