#!/bin/bash

mkdir -p /etc/hysteria

# توليد شهادة TLS ذاتية
openssl req -x509 -nodes -newkey rsa:2048 \
-keyout /etc/hysteria/server.key \
-out /etc/hysteria/server.crt \
-days 3650 \
-subj "/CN=www.cloudflare.com"

# إنشاء config
cat > /etc/hysteria/config.yaml <<EOF
listen: :${PORT:-443}

tls:
  cert: /etc/hysteria/server.crt
  key: /etc/hysteria/server.key

auth:
  type: password
  password: ${HY2_PASSWORD:-123456}

masquerade:
  type: proxy
  proxy:
    url: https://www.cloudflare.com

bandwidth:
  up: 100 mbps
  down: 100 mbps
EOF

exec hysteria server -c /etc/hysteria/config.yaml
