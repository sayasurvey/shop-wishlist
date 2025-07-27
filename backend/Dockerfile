FROM php:8.2-fpm

# システムパッケージのインストール
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Composerのインストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 作業ディレクトリの設定
WORKDIR /var/www/html

# Laravelプロジェクトの作成
RUN composer create-project laravel/laravel . --prefer-dist

# .envファイルの設定
RUN cp .env.example .env || true

# アプリケーションキーの生成
RUN php artisan key:generate

# 権限設定
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 777 storage bootstrap/cache

# ポート8000で起動
EXPOSE 8000

# Laravel開発サーバーの起動
CMD php artisan serve --host=0.0.0.0 --port=8000