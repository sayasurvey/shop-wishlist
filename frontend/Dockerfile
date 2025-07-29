FROM cirrusci/flutter:stable

WORKDIR /app

COPY . .

RUN flutter config --enable-web

RUN flutter pub get

EXPOSE 3000

CMD ["flutter", "run", "-d", "web-server", "--web-port", "3000", "--web-hostname", "0.0.0.0"]
