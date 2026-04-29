FROM alpine:latest

# تثبيت المتطلبات (Hysteria + Python للواجهة + Openssl)
RUN apk add --no-cache ca-certificates bash openssl curl python3

# تحميل Hysteria2
RUN curl -Lo /app/hysteria https://github.com/apernet/hysteria/releases/latest/download/hysteria-linux-amd64 && \
    chmod +x /app/hysteria

WORKDIR /app
COPY . .
RUN chmod +x entrypoint.sh

# المتغيرات الأساسية (يمكنك تغييرها من إعدادات Railway)
ENV PORT=8080
ENV PASSWORD=abu_eyad_2026

ENTRYPOINT ["/app/entrypoint.sh"]
