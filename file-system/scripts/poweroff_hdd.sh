#/bin/bash

sudo hdparm -S 3 /dev/sda
sudo hdparm -S 3 /dev/sdb
sleep 30
sudo hdparm -Y /dev/sda
sudo hdparm -Y /dev/sdb
