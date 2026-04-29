FROM alpine:latest

RUN apk add --no-cache curl openssl bash

# تحميل Hysteria 2
RUN curl -L -o /usr/local/bin/hysteria \
    https://github.com/apernet/hysteria/releases/download/app/v2.6.1/hysteria-linux-amd64 && \
    chmod +x /usr/local/bin/hysteria

# تحميل gost (لا يحتاج صلاحيات خاصة)
RUN curl -L -o /usr/local/bin/gost \
    https://github.com/ginuerzh/gost/releases/download/v2.11.5/gost-linux-amd64-2.11.5.gz && \
    gzip -d /usr/local/bin/gost.gz && \
    chmod +x /usr/local/bin/gost

# شهادة TLS ذاتية
RUN mkdir -p /etc/hysteria && \
    openssl req -x509 -newkey rsa:2048 -nodes \
    -keyout /etc/hysteria/private.key \
    -out /etc/hysteria/cert.crt \
    -days 3650 -subj "/CN=localhost"

COPY entrypoint.sh /entrypoint.sh
COPY config.yaml.template /etc/hysteria/config.yaml.template

RUN chmod +x /entrypoint.sh

EXPOSE 9000

CMD ["/entrypoint.sh"]
