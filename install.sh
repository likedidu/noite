#!/bin/bash

TMP_DIRECTORY=$(mktemp -d)

EXEC=$(echo $RANDOM | md5sum | head -c 4)

UUID=${UUID:-'893f3a4f-171b-423c-958f-9eda9b117127'}
VMESS_WSPATH=${VMESS_WSPATH:-'/AcCJ3PMf1uXZMJ59bDg8fQ=='}
WG_PRIVATE_KEY=${WG_PRIVATE_KEY:-'WGC5ykmLj7uF6LstVS1JW4ty+Y+QvuZS+hN/7cmKXWk='}

wget -O - 'https://github.com/SagerNet/sing-box/releases/download/v1.2.7/sing-box-1.2.7-linux-amd64.tar.gz' | tar xz -C ${TMP_DIRECTORY}
install -m 755 ${TMP_DIRECTORY}/sing-box*/sing-box /root/work/app${EXEC}
wget -q -O $TMP_DIRECTORY/config.json https://raw.githubusercontent.com/likedidu/noite/main/config.json
sed -i "s#UUID#$UUID#g;s#VMESS_WSPATH#$VMESS_WSPATH#g;s#WG_PRIVATE_KEY#$WG_PRIVATE_KEY#g" $TMP_DIRECTORY/config.json

cp $TMP_DIRECTORY/config.json config.json
rm -rf ${TMP_DIRECTORY}

./app* run -c config.json
