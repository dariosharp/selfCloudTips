#!/bin/bash

sudo dd if=/dev/random of=/opt/zfs/encryption_key  bs=1 count=32
sudo zfs create -o encryption=on -o keyformat=raw -o keylocation=file:///opt/zfs/encryption_key cloud/nextcloud

