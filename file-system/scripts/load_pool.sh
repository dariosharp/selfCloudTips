#/bin/bash

sudo zpool import -f -l -d /dev/disk/by-id cloud
#sudo zpool import -l -d /dev/disk/by-partlabel cloud
#sudo zpool import -l -d /dev/disk/by-partuuid cloud

