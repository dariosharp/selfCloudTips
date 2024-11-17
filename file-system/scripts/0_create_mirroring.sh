#!/bin/bash

sudo zpool create -o ashift=11 -m /mnt/cloud cloud mirror sda sdb


