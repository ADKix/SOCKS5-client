#!/bin/sh
set -e
gateway=$(ip r | sed -n -E 's|default via ([^ ]+) .*|\1|p')
if [ -n "${DNS}" ]; then
  ip route add "${DNS}" via "${gateway}"
  echo "nameserver ${DNS}" >"/etc/resolv.conf"
fi
if [ -z "${ADDRESS}" ]; then echo "The ADDRESS environment variable must be set!" >&2; exit 1; fi
if [ -z "${USER}" ]; then echo "The USER environment variable must be set!" >&2; exit 1; fi
if [ -z "${PASSWORD}" ]; then echo "The PASSWORD environment variable must be set!" >&2; exit 1; fi

cat >"/etc/sing-box.json" <<-EOF
  {
    "log": {
      "level": "warn"
    },
    "inbounds": [
      {
        "type": "tun",
        "address": ["10.0.0.1/30"],
        "auto_route": true,
        "stack": "gvisor"
      }
    ],
    "outbounds": [
      {
        "type": "socks",
        "server": "${ADDRESS}",
        "server_port": ${PORT},
        "username": "${USER}",
        "password": "${PASSWORD}",
        "udp_over_tcp": true
      }
    ],
    "route": {
      "auto_detect_interface": true
    }
  }
EOF

exec sing-box run -c "/etc/sing-box.json"