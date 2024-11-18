# File-system
Choosing the correct file system is essential for ensuring data reliability and efficiency. 
My solution involves adopting Open Zettabyte File System (ZFS). ZFS is designed to guarantee high data reliability by detecting data corruption and restoring it quickly and easily.

# TOC
 - EXT4 vs XFS vs BtrFS vs ZFS
 - How to configure ZTF


# EXT4 vs XFS vs BtrFS vs ZFS
GNU/Linux is able to manage multiple file-system types. The most famous and used are EXT4, XFS, BtrFS and Open ZFS.

- **EXT4**, or Fourth Extended File System, is a widely-used file system in Linux environments, known for its reliability and performance. Key features of EXT4 include journal checksumming for improved data integrity, delayed allocation to boost performance, and extents, which improve the handling of large files and reduce fragmentation.
- **XFS** is a high-performance, journaling file system originally developed by Silicon Graphics and now widely used in Linux environments.
  Designed for scalability and efficiency, XFS excels in handling large files and high-capacity storage systems.
  Its key features include support for large file sizes and volumes, efficient space management, and advanced data integrity through journaling.
- **Btrfs**, or B-Tree File System, is a modern file system for Linux designed with advanced features and scalability in mind.
  Developed as a replacement for older file systems like EXT4, Btrfs offers robust data management capabilities, including support for snapshots, built-in RAID functionality, and dynamic volume resizing.
- **ZFS** (Zettabyte File System) is an advanced file system and volume manager originally developed by Sun Microsystems for the Solaris operating system, and now available for other platforms like Linux and FreeBSD. It is renowned for its robustness and scalability, integrating both file system and volume management into a single unified solution. ZFS ensures data integrity through its use of checksumming for both data and metadata, which helps detect and correct data corruption. It also incorporates self-healing capabilities, automatically repairing corrupted data using redundant copies, and includes built-in support for advanced RAID configurations. This combination of features makes ZFS a powerful and flexible choice for managing high-performance storage needs.

<div align="center">
 
|       Feature          |  EXT4  |   XFS   | Btrfs  |  ZFS  |
|:----------------------:|:------:|:-------:|:------:|:-----:|
| Expansion              |   ✅   |   ✅    |   ✅   |  ✅   |
| Reduction              |   ✅   |   ✅    |   ✅   |  ❌   |
| Logical volume manager |   ❌   |   ❌    |   ✅   |  ✅   |
| Checksum on data       |   ❌   |   ❌    |   ✅   |  ✅   |
| Checksum on metadata   |   ✅   |   ✅    |   ✅   |  ✅   |
| Compression support    |   ❌   |   ❌    |   ✅   |  ✅   |
| Filesystem encryption  |   ❌   |   ❌    |   ❌   |  ✅   |
| Copy-on-Write          |   ❌   |   ✅    |   ✅   |  ✅   |
| Snapshots              |   ❌   |   ✅    |   ✅   |  ✅   |

</div>

**Some consideration**: 
- There are multiple other comparison features that should be noted, but the ones listed above, in my opinion, are the most important.
- Checksum is used to detect if data or metadata is corrupted. Filesystems that do not support this feature are unable to detect if a file has been corrupted.
- Copy-o-Write is a feature that prevents data from being overwritten. It is useful in case of a failure during writing. 
- Logical volume manager means that the filesystem is able to manage RAID setups.

**Summarizing**:
ZFS can detect corrupted files, supports RAID without the use of additional tools, and provides Copy-on-Write (CoW) and Snapshots. This makes ZFS very reliable and powerful for managing RAID and data that needs to be stored for a long time.

# How to configure ZFS 
Supposing you have bought the Zimablade (or a similar device) and want to use ZFS as the filesystem to manage mirroring two HDDs, you will need to read multiple documents carefully to configure the ZFS filesystem as effectively as possible.
In a nutshell, the essential concepts you need to know about ZFS are as follows:
- A group of HDDs is called a **Pool**; essentially, a pool is a RAID setup.
- To access the pool, you need to create a **dataset**, which functions like a directory.

There are multiple well-written documents about ZFS. I suggest reading all of them carefully:
- A very good blog about how to use ZFS tools: https://briankoopman.com/moving/
- Installation and how to use ZFS tools: https://wiki.archlinux.org/title/ZFS#Advanced_format_disks
- Example how to create and configure ZFS: https://wiki.archlinux.org/title/ZFS/Virtual_disks
- OpenZFS official documentation: https://openzfs.github.io/openzfs-docs/Project%20and%20Community/FAQ.html#performance-considerations

In the link above, all the information needed to configure ZFS properly is provided. My recommendations are:
- Enable compression during the pool creation; this will increase speed and extend HDD life.
- Encryption is not necessary for this project, as Nextcloud can manage encryption.
- Properly configure the dimensions of the HDD during pool creation; this will increase speed and extend HDD life.

## My configuration
[here](https://github.com/dariosharp/selfCloudTips/tree/main/file-system/scripts) is a list of scripts for configuring, replacing, monitoring, and optimizing ZFS and hard drive configurations. 
### How I have create the mirroring:
- **0_create_mirroring.sh**: Used to create a mirror between two hard drives.
  
  `sudo zpool create -o ashift=11 -m /mnt/cloud cloud mirror sda sdb`
  
This configuration is for the IronWolf Pro NAS hard drives (described in the hardware folder) that I purchased and set up in a mirrored RAID 1 configuration
- **1_create_dataset.sh**: Used to create and encrypt a new dataset. The script create the key to encrypt the dataset, it is strongly suggested to save a copy somewhere outside the board. 
- **2_configure_dataset.sh**: Used to compress files.
  
### How I handle the scrubbing:
I have created two scripts useful for scrubbing:
- **scrub.sh**: Used to run the scrubbing process.  
- **check_status.sh**: A script for monitoring the status of scrubbing and the hard drives.  
- **bot_scrub_notification.sh**: Sends a Telegram notification to keep me updated on the scrubbing process.  
  - This script is very useful, as I run scrubs once per month.  
  - When the scrubbing ends, I receive a notification detailing the status of the hard drives, including any detected errors.

In order to perform periodic scrubs, I have created a `systemctl` service called `zfs-scrub@cloud.timer`, as described [here](https://wiki.archlinux.org/title/ZFS#Advanced_format_disks) in section 6.2.  

To execute the notification script, I modified the script from the wiki as follows:
```
[Unit]
Description=zpool scrub on %i

[Service]
Nice=19
IOSchedulingClass=idle
KillSignal=SIGINT
ExecStart=/usr/sbin/zpool scrub %i
ExecStop=/opt/zfs/bot_scrub_notification.sh 

[Install]
WantedBy=multi-user.target
```
I suggest reviewing the default cron jobs. When I installed the ZFS tools, the cron jobs were automatically updated to include tasks such as scrubbing, trimming, and snapshotting. I have removed all of them.

### How I Handle Snapshotting and Backups in Case of HDD Failure:
Snapshots in ZFS are used to restore a previous file system state and to export data. They can be added and removed without any issues. I take snapshots every month to maintain a partial history in case of failure.

Additionally, to enhance data reliability, snapshots can be used to back up all the data to another device. I also back up the snapshots to the cloud to safeguard against the failure of both hard drives.


To automate monthly snapshots, I created a script in `/etc/cron.monthly`:

```
#!/bin/sh

which zfs-auto-snapshot > /dev/null || exit 0

exec zfs-auto-snapshot --quiet --syslog --label=monthly --keep=12 //
```
With the command `zfs list -t snapshot`, you can list the snapshots that have been created.

#### How to back up the back up:
To increase the reliability of the data, it is essential to back up the snapshots. This ensures protection in case both disks fail. There are several cost-effective solutions for backing up snapshots. For instance, you could use `AWS Deep Archive`, which is very affordable, or purchase an additional hard drive to use as a backup and store it in a different location.

There are also projects that allow you to store data, such as encoding it into a YouTube video, which can be done for free, but is to hard to handle in case of data restoring.  

My solution, however, involves a little hack using Google Drive (if Google hadn’t rejected me, I probably wouldn’t be sharing this hack). Essentially, Google Drive allows you to access and download your data for up to two years, even if you exceed your storage quota. To take advantage of this, I created a new Google account, waited until I received the free 200GB Google Drive trial, and uploaded the snapshots there. Once a year, I upload new snapshots to maintain the backup.

## Managing HDD Energy Consumption:
The Zimablade with Linux allows interaction with the motherboard using the `hdparm` command, which manages the status of the HDD. This includes stopping the disk's rotation to conserve energy. A significant portion of the energy consumed by my cloud setup comes from the continuous spinning of the HDD. Since I don’t access the HDD all day or use my cloud daily, leaving the HDD spinning during idle periods wastes energy. To address this, I configured the HDD to enter sleep mode after a few minutes of inactivity. 

I created a script called **sleep_hdd.sh**, which includes the necessary commands to automatically put both HDDs into sleep mode after 180 * 5 seconds (approximately 15 minutes) of inactivity. When a tool (e.g., Nextcloud) needs to access the sleeping HDD, the kernel automatically handles waking the disk and restarting its rotation.


The primary drawback of this setup is a slight delay when accessing data for the first time after the HDD has gone to sleep. For example:  
- When accessing a photo, you may need to wait 5–10 seconds for the HDD to spin up.  

However, since I only access Nextcloud a couple of times per week, and photo uploads are automated, I hardly notice the delay. In my use case, the energy savings from stopping the disk's rotation outweigh the occasional wait time.

This setup is an effective way to reduce energy consumption in my cloud system while maintaining reasonable performance. It balances sustainability and usability, aligning with my infrequent usage patterns.

To properly configure the HDD sleep settings, it is necessary to run the `hdparm` command every time the device boots. To automate this process, I have set up a `crontab` job that executes the `hdparm` command at startup.
```
@reboot root /usr/sbin/hdparm -S 90 /dev/disk/by-id/id-hdd2
@reboot root /usr/sbin/hdparm -S 90 /dev/disk/by-id/id-hdd1
```





