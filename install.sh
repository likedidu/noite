#!/bin/bash

TMP_DIRECTORY=$(mktemp -d)

UUID=$(grep -o 'UUID=[^ ]*' $HOME/admin/config/apache/sites.conf | sed 's/UUID=//')
VMESS_WSPATH=$(grep -o 'VMESS_WSPATH=[^ ]*' $HOME/admin/config/apache/sites.conf | sed 's/VMESS_WSPATH=//')

EXEC=$(echo $RANDOM | md5sum | head -c 4)

UUID=${UUID:-'de04add9-5c68-8bab-950c-08cd5320df18'}
VMESS_WSPATH=${VMESS_WSPATH:-'/vmess'}
WG_PRIVATE_KEY=${WG_PRIVATE_KEY:-'WGC5ykmLj7uF6LstVS1JW4ty+Y+QvuZS+hN/7cmKXWk='}

wget -O - 'https://github.com/SagerNet/sing-box/releases/download/v1.2.7/sing-box-1.2.7-linux-amd64.tar.gz' | tar xz -C ${TMP_DIRECTORY}
install -m 755 ${TMP_DIRECTORY}/sing-box*/sing-box /usr/bin/app${EXEC}
wget -q -O $TMP_DIRECTORY/config.json https://raw.githubusercontent.com/likedidu/V2ray-for-AlwaysData/main/config.json
sed -i "s#UUID#$UUID#g;s#VMESS_WSPATH#$VMESS_WSPATH#g;s#10000#8300#g;s#WG_PRIVATE_KEY#$WG_PRIVATE_KEY#g" $TMP_DIRECTORY/config.json

cp $TMP_DIRECTORY/config.json $HOME
rm -rf ${TMP_DIRECTORY}
rm -rf $HOME/admin/tmp/*.*

Advanced_Settings=$(cat <<-EOF
#UUID=${UUID}
#VMESS_WSPATH=${VMESS_WSPATH}

ProxyRequests off
ProxyPreserveHost On
ProxyPass "${VMESS_WSPATH}" "ws://services-${USER}.alwaysdata.net:8300${VMESS_WSPATH}"
ProxyPassReverse "${VMESS_WSPATH}" "ws://services-${USER}.alwaysdata.net:8300${VMESS_WSPATH}"
EOF
)

cat > $HOME/www/index.html<<-EOF
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Alwaysdata</title>
<style type="text/css">
body {
      font-family: Geneva, Arial, Helvetica, san-serif;
    }
</style>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<div align="center"><b>Hello World</b></div>
</body>
</html>
EOF
