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
- Logical volume manager means that the filesystem is able to manage RAID setups..

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


