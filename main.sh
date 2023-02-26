#!/bin/bash
# Create By xiaowansm
# Modlfy By ifeng
# Web Site:https://www.hicairo.com
# Telegram:https://t.me/HiaiFeng

export PATH="~/nginx/sbin:~/v2ray/sbin:$PATH"

chmod a+x .nginx/sbin/nginx .v2ray/sbin/v2ray .v2ray/sbin/v2ctl .v2ray/sbin/qrencode

if [ ! -d "~/nginx" ];then
	\cp -ax .nginx ~/nginx
fi
if [ ! -d "~/v2ray" ];then
	\cp -ax .v2ray ~/v2ray
fi

UUID='7d88c645-c74b-4913-ad41-e3f7fe551a1f'
VMESS_WSPATH=${VMESS_WSPATH:-'/data8878M'}
VLESS_WSPATH=${VLESS_WSPATH:-'/data8878L'}

sed -i "s#[0-9a-f]\{8\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{4\}-[0-9a-f]\{12\}#$UUID#g;s#/vmess#$VMESS_WSPATH#g;s#/vless#$VLESS_WSPATH#g" ~/v2ray/etc/config.json
sed -i "s#/vmess#$VMESS_WSPATH#g;s#/vless#$VLESS_WSPATH#g" ~/nginx/conf/conf.d/default.conf

URL=${REPL_SLUG}.${REPL_OWNER}.repl.co

vmesslink=vmess://$(echo -n "{\"v\":\"2\",\"ps\":\"hicairo.com\",\"add\":\"$URL\",\"port\":\"443\",\"id\":\"$UUID\",\"aid\":\"0\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"$URL\",\"path\":\"$VMESS_WSPATH\",\"tls\":\"tls\"}" | base64 -w 0)
vlesslink="vless://"$UUID"@"$URL":443?encryption=none&security=tls&type=ws&host="$URL"&path="$VLESS_WSPATH"#hicairo.com"

echo -e "\e[31mVMess协议链接：\n\e[0m$vmesslink\n\n\e[31mVLess协议链接：\n\e[0m$vlesslink"

echo -e "\n\e[31mVMess协议链接二维码：\n\e[0m"
qrencode -o - -t UTF8 $vmesslink
echo -e "\n\e[31mVLess协议链接二维码：\n\e[0m"
qrencode -o - -t UTF8 $vlesslink

while true; do curl -s "https://$URL" >/dev/null; echo "$(date +'%Y%m%d%H%M%S') Keeping online ..."; sleep 300; done &

v2ray -config ~/v2ray/etc/config.json >/dev/null 2>&1 &
nginx -g 'daemon off;'
