FROM cirrusci/flutter:stable

# 作業ディレクトリの設定
WORKDIR /app

# プロジェクトファイルをコピー
COPY . .

# Flutterのweb有効化
RUN flutter config --enable-web

# 依存関係のインストール
RUN flutter pub get

# ポート3000で起動
EXPOSE 3000

# デフォルトコマンド
CMD ["flutter", "run", "-d", "web-server", "--web-port", "3000", "--web-hostname", "0.0.0.0"]