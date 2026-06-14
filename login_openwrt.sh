#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
if [ -f "$SCRIPT_DIR/.env" ]; then
  . "$SCRIPT_DIR/.env"
fi

# 以下变量优先于 .env，如需使用 .env 中的值请注释掉对应行
USERID=20xxxxxxxxx
PASSWORD=abcdefxxxxxx
# 中国移动：cmcc 中国电信：telecom
CHANNEL=cmcc

http_get() {
  if command -v curl >/dev/null 2>&1; then
    curl -s "$1"
  elif command -v wget >/dev/null 2>&1; then
    wget -q -O - "$1"
  else
    echo "Neither curl nor wget is available." | logger
    return 1
  fi
}

http_probe() {
  if command -v curl >/dev/null 2>&1; then
    curl -IsS -m 5 "$1" >/dev/null 2>&1
  elif command -v wget >/dev/null 2>&1; then
    wget -q -T 5 -O /dev/null "$1" >/dev/null 2>&1
  else
    echo "Neither curl nor wget is available." | logger
    return 1
  fi
}

#WANIP=$(ifconfig eth0 | grep 'inet addr' | cut -d ':' -f2 | cut -d ' ' -f1)
#从接口获取
WANIP=`http_get "http://10.50.255.11/a79.htm" 2>/dev/null | sed -n "s/^.*v46ip='\(.*\)'.*$/\1/p"`
#从web获取

LOGIN_URL="http://10.50.255.11:801/eportal/portal/login"
LOGIN_REQUEST_URL="${LOGIN_URL}?callback=dr1003&login_method=1&user_account=%2C1%2C${USERID}%40${CHANNEL}&user_password=${PASSWORD}&wlan_user_ip=${WANIP}&wlan_user_ipv6=&wlan_user_mac=000000000000&wlan_ac_ip=&wlan_ac_name=&jsVersion=4.1.3&terminal_type=2&lang=zh-cn&v=8166&lang=zh"

url="http://www.baidu.com"

if http_probe "$url"; then
    echo "Internet connection is active!" | logger
else
    echo "Internet connecting..." | logger
    http_get "$LOGIN_REQUEST_URL"
    echo
    echo "Internet connection is active!" | logger
fi
