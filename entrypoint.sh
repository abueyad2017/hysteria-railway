#!/bin/bash

mkdir -p /etc/xray

# توليد شهادة TLS
openssl req -x509 -nodes -newkey rsa:2048 \
-keyout /etc/xray/key.pem \
-out /etc/xray/cert.pem \
-days 3650 \
-subj "/CN=www.cloudflare.com"

# إعداد البورت من Railway
PORT=${PORT:-443}

# إنشاء config النهائي
cat > /etc/xray/config.json <<EOF
{
  "inbounds": [
    {
      "port": ${PORT},
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password": "${PASSWORD:-123456}"
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/xray/cert.pem",
              "keyFile": "/etc/xray/key.pem"
            }
          ]
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

exec xray run -c /etc/xray/config.json
