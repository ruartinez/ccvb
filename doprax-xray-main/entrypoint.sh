#!/bin/sh
apt update && apt install -y supervisor wget unzip iproute2
# wget -O temp.zip https://github.com/XTLS/Xray-core/releases/download/v1.7.2/Xray-linux-64.zip
wget -qO- https://api.github.com/repos/XTLS/Xray-core/releases/latest | grep -o '"https://github.com/XTLS/Xray-core/releases/download/.*/Xray-linux-64.zip"' | xargs wget -O m.zip
unzip m.zip
chmod a+x xray
sed -i "s/uuid/$uuid/g" ./config.yaml
sed -i "s/uuid/$uuid/g" /etc/nginx/nginx.conf
[ -n "${www}" ] && rm -rf /usr/share/nginx/* && wget -c -P /usr/share/nginx "https://gitlab.com/rwkgyg/doprax-xray/-/raw/main/3w/html${www}.zip" && unzip -o "/usr/share/nginx/html${www}.zip" -d /usr/share/nginx/html
xpid=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 6)
mv xray $xpid
cat config.yaml | base64 > config
rm -f config.yaml
nginx
base64 -d config > config.yaml; ./$xpid -config=config.yaml
