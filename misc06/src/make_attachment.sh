#!/usr/bin/bash -e

rm -r intent_bakery || :
mkdir intent_bakery

cp docker-compose.yml  ./intent_bakery
cp -r ./emu ./intent_bakery
cp -r ./web ./intent_bakery
rm -r ./intent_bakery/web/venv
cp ./vuln_no_flag.apk ./intent_bakery/web/vuln.apk

rm ../attachments/intent_bakery.zip
zip -r ../attachments/intent_bakery.zip ./intent_bakery
rm -r intent_bakery