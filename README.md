# お店毎の商品管理アプリ

SNSで見つけた気になる商品をお店毎に整理・管理できるアプリケーション。

## 技術スタック
- **フロントエンド**: Flutter (ローカル実行)
- **バックエンド**: Laravel (Docker)
- **データベース**: MySQL (Docker)

## セットアップ手順

### 1. 環境設定ファイルの準備
```bash
# .env.exampleをコピーして.envファイルを作成
cp .env.example .env

# 必要に応じて.envファイルの値を編集
vi .env
```

### 2. Docker環境の起動
```bash
# Laravel + MySQLコンテナの起動
docker-compose up -d

# または
docker compose up -d
```

### 3. Flutter環境の起動
```bash
# Flutterディレクトリに移動
cd frontend

# 依存関係のインストール
flutter pub get

# Web開発サーバーの起動
flutter run -d web-server --web-port 3000 --web-hostname 0.0.0.0
```

## アクセス方法
- **Flutter Web**: http://localhost:3000
- **Laravel API**: http://localhost:8000
- **MySQL**: localhost:3306

## セキュリティ
- 機密情報は`.env`ファイルで管理
- `.env`ファイルはGitの管理対象外
- 新しい環境では`.env.example`をコピーして使用

## 主要機能
- お店一覧の表示
- お店別の商品一覧表示
- 商品詳細表示
- 商品の登録（将来実装予定）
- 商品画像のアップロード（将来実装予定）