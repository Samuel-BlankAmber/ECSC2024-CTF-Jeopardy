#!/bin/bash

rm ../attachments/topcpu.zip
mkdir topcpu
cp TopCPU* topcpu
zip -r ../attachments/topcpu.zip topcpu
rm -rf topcpu
echo "[+] done"
