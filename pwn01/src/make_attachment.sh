#!/bin/sh

CHALL=yap

echo "[+] copying chall files"
mkdir $CHALL
cp -r docker-compose.yml Dockerfile chall.py setup.py yapmodule.c README.md $CHALL
echo "[+] redacting flag"
sed -i "s/^\([[:space:]]*-\s*'FLAG=\).*/\1ECSC{fake_flag}'/" $CHALL/docker-compose.yml
echo "[+] zipping files"
zip -r $CHALL.zip $CHALL
mv $CHALL.zip ../attachments
rm -rf $CHALL
echo "[+] done"