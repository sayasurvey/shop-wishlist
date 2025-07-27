# お店毎の商品管理アプリ

## 概要
SNSで見つけた気になる商品をお店毎に整理・管理できるアプリケーション。商品の画像やお店の情報を紐付けて保存し、後からお店別に商品を確認できる。

## 技術スタック
- フロントエンド: Flutter
- バックエンド: Laravel
- データベース: PostgreSQL
- インフラ: Docker

## 主要機能
1. お店一覧の表示
2. お店別の商品一覧表示  
3. 商品の登録（複数店舗への紐付け可能）
4. 商品画像のアップロード

## Docker環境構築

### docker-compose.yml
```yaml
version: '3.8'

services:
  laravel:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    volumes:
      - ./backend:/var/www/html
    environment:
      - DB_CONNECTION=mysql
      - DB_HOST=mysql
      - DB_PORT=3306
      - DB_DATABASE=shop_products
      - DB_USERNAME=user
      - DB_PASSWORD=password
    depends_on:
      - mysql

  mysql:
    image: mysql:8.0
    ports:
      - "3306:3306"
    environment:
      - MYSQL_DATABASE=shop_products
      - MYSQL_USER=user
      - MYSQL_PASSWORD=password
      - MYSQL_ROOT_PASSWORD=root_password
    volumes:
      - mysql_data:/var/lib/mysql

  flutter:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app
    command: flutter run -d web-server --web-port 3000 --web-hostname 0.0.0.0

volumes:
  mysql_data:
```

## データベース設計

### shops (お店)
- id: bigint (PK)
- name: varchar(255) NOT NULL
- created_at: timestamp
- updated_at: timestamp

### products (商品)
- id: bigint (PK)
- name: varchar(255) NOT NULL
- image_path: varchar(255) NULL
- created_at: timestamp
- updated_at: timestamp

### product_shop (中間テーブル)
- id: bigint (PK)
- product_id: bigint (FK → products.id)
- shop_id: bigint (FK → shops.id)
- created_at: timestamp
- UNIQUE(product_id, shop_id)

## API設計

### お店関連
- `GET /api/shops` - お店一覧取得
- `POST /api/shops` - お店登録
- `GET /api/shops/{id}/products` - 特定お店の商品一覧

### 商品関連
- `POST /api/products` - 商品登録（画像付き）
  - リクエスト: name(必須), shop_ids[](必須), image(任意)
  - レスポンス: 登録された商品情報

## 画面構成

### 1. お店一覧画面
- お店の名前と商品数を表示
- タップで商品一覧へ遷移
- FABから商品登録画面へ

### 2. 商品一覧画面
- 選択したお店の商品を一覧表示
- 商品名と画像を表示

### 3. 商品登録画面
- 商品名入力（必須）
- お店選択（必須・複数選択可）
- 画像選択（任意）

## Laravel実装ポイント

### マイグレーション作成
```bash
php artisan make:model Shop -m
php artisan make:model Product -m
php artisan make:migration create_product_shop_table
```

### リレーション設定
- Shop::products() - belongsToMany
- Product::shops() - belongsToMany

### 画像アップロード
- storage/app/public/productsに保存
- シンボリックリンク作成: `php artisan storage:link`

### API認証
- 初期実装では認証なし
- 本番環境ではLaravel Sanctum推奨

## Flutter実装ポイント

### 必要パッケージ
- http: API通信
- image_picker: 画像選択
- cached_network_image: 画像キャッシュ

### 状態管理
- シンプルな実装ではsetState使用
- 複雑になったらProvider/Riverpod検討

### エラーハンドリング
- API通信失敗時のリトライ
- オフライン時の対応

## 開発フロー

1. Dockerコンテナ起動
   ```bash
   docker-compose up -d
   ```

2. Laravelセットアップ
   ```bash
   docker exec -it laravel-container bash
   composer install
   php artisan migrate
   ```

3. Flutter開発
   ```bash
   docker exec -it flutter-container bash
   flutter pub get
   flutter run
   ```

## 今後の拡張案
- 商品の検索機能
- カテゴリ分類
- 価格情報の記録
- 購入済みフラグ
- メモ機能