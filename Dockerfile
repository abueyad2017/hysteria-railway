# استخدام نسخة Alpine الحديثة والمستقرة
FROM python:3.11-alpine

# تثبيت المتطلبات (curl, openssl, bash) في سطر واحد سريع
RUN apk add --no-cache curl openssl bash

WORKDIR /app

# تحميل وحش السرعة Hysteria2 مباشرة
RUN curl -Lo /app/hysteria https://github.com/apernet/hysteria/releases/latest/download/hysteria-linux-amd64 && \
    chmod +x /app/hysteria

# نسخ ملفاتك (index.html و entrypoint.sh)
COPY . .

# منح صلاحيات التشغيل
RUN chmod +x entrypoint.sh

# السيرفر سيعتمد على المنفذ الذي يحدده Railway تلقائياً
CMD ["./entrypoint.sh"]
