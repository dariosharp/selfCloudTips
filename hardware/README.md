# Hardware
My solution consists of a single-board computer and two hard disk drives. I was looking for a low-power consumption computer and a reliable solution for data storage.
The two hardware components to choose are:
- The board (the computer), which is responsible for managing all the software.
- The disks, which are responsible for managing all the data.

# TOC
 - Board
   - My Board Solution
 - Disks
   - How to chose the correct RAID
   - How to chose the Disks
   - My disks solution

# Board
There are multiple board solutions for NAS and cloud setups, such as the Raspberry Pi 4/5 or Orange Pi, and all of them are good alternatives to the ZimaBlade. However, I chose to buy the ZimaBlade because it offers two SATA interfaces. Its 4-core Intel processor and 16 GB of RAM can easily handle multiple instances of NextCloud. Unlike the other boards, which are designed for various IoT purposes, the ZimaBlade is specifically developed for NAS use. This made it the ideal choice for my cloud blade solution.

## My Board solution
My solution was the **ZimaBlade 7700 NAS Kit**, which incluses:
  - The board ZimaBlade 7700
  - 16 GB of RAM
  - 2 Bay HDD Rack
  - SATA Y Cable
  - The power adapter
  - Mini Display port to HDMI

<img src="https://github.com/user-attachments/assets/444716aa-8e6d-4b66-b7b2-b73ec9077c2a" alt="Zimablade 7700 Nas Kit" width="450" height="400">

Costs: ~200€ (including Tax and spedition)


# Disks
Choosing the board was not very time-consuming; I watched a few videos on YouTube and found my solution. However, selecting the HDDs was not as easy and took a long time. There are multiple factors to consider. Before choosing the disks, it is crucial to decide how many HDDs to use and which RAID type to implement.

## How to chose the correct RAID
The use of RAID configuration is very important to increase the reliability of the data. There are differet RAID configuration, but only two have to be noted: RAID 1 and RAID 5.
For more details: https://en.wikipedia.org/wiki/RAID

I decided to use RAID 1 because is easier and faster to replace a failure disk. 


### RAID 1
RAID 1, or mirroring, is a RAID configuration that provides a high level of data redundancy. It works by creating an identical copy of all data on two or more disks. This means that if one disk fails, the data can be recovered from the other disk(s) without any loss.

<img src="https://github.com/user-attachments/assets/48c12526-186e-46c0-979b-514f06ede598" alt="RAID1" width="450" height="300">

PROs:
- High reliability: Data redundancy provides strong protection against data loss in case of a disk failure.
- Fast recovery times: If a disk fails, the system can be quickly restored using the mirrored disk.
- Improved read performance: Read operations can be distributed across both disks, enhancing overall performance.

Cons:
- High cost: Requires purchasing two or more disks of the same size, increasing the initial cost of the system.
- Reduced storage capacity: The effective storage capacity is limited to that of the smallest disk in the RAID array, as only half of the total capacity is usable for data.
- Poor write efficiency: Each write operation must be performed on both disks, which can negatively impact write performance, especially under intensive workloads.

**Overall**: In case of a disk failure, RAID 1 makes it easy and quick to duplicate data onto a new HDD. However, the available storage space is effectively divided in half. 


### RAID 5
RAID 5 is a popular storage configuration that provides a good balance between performance, redundancy, and cost-effectiveness. However, it is important to understand its strengths and weaknesses before implementing it.

<img src="https://github.com/user-attachments/assets/7cbbda0a-4561-45d9-a851-91b6093957ed" alt="RAID5" width="450" height="300">

Pros of RAID 5:
- Data redundancy: Protects against the failure of a single drive.
- Improved read performance: Can significantly boost read speeds compared to a single drive.
- Cost-effective: Generally more affordable than other RAID levels that offer similar redundancy.
- Balanced performance and redundancy: Provides a good compromise between speed and data protection.

Cons of RAID 5:
- Write performance penalty: Due to parity calculations, write speeds can be slower compared to other RAID levels.
- Single point of failure: If two drives fail simultaneously, data loss is likely.
- Long rebuild time: Rebuilding a failed drive can be time-consuming and resource-intensive.
- Reduced usable capacity: The equivalent of one drive's storage is used for parity information.
    
**Overall**: In the event of a disk failure, RAID 5 requires a significant amount of time to rebuild and duplicate data onto a new HDD. However, the usable storage space is reduced by approximately one-third due to parity storage.


## How to chose the disks
Once you've decided on the RAID level, it's time to choose the type of HDD to buy. While selecting an HDD might seem straightforward, it's important to be careful and consider several factors:
- Capacity: Larger capacity drives (more TBs) are generally more prone to failures, so it's usually not recommended to choose the highest capacity available.
- Technology: SSDs vs. HDDs
  - SSDs: More expensive than HDDs but require less energy and are generally more reliable. I decided to use HDDs due to their lower cost; SSDs are currently about 2.5 times the price of HDDs.
  - HDDs: While more affordable, they come in different types based on recording technology.
- CMR vs. SMR:
  - CMR (Conventional Magnetic Recording):
    - Pros: Faster read and write speeds, especially for random data access.
    - Cons: Lower storage density compared to SMR.
  - SMR (Shingled Magnetic Recording):
    - Pros: Higher storage capacity for the same physical size.
    - Cons: Slower write speeds, particularly when overwriting existing data.
- Reseller Considerations: It is advisable not to buy all your HDDs or SSDs from the same reseller at the same time. Purchasing from the same source could increase the risk of simultaneous failures if the disks come from the same production batch. Consider buying from different resellers to mitigate this risk.

**Overall**: CMR HDDs purchased from different resellers provide high reliability and cost-effective storage solutions.


## My disks solution

I bought tow Seagate IronWolf Pro, 4TB, Hard Disk SATA da 6GBit/s, HDD, CMR 3,5" 7.200 RPM, Cache da 128 MB

<img src="https://github.com/user-attachments/assets/a2df0e7b-d8cb-4781-9425-a5c941cf5025" alt="HDD" width="300" height="400">

Costs: ~200€ for both the HDDs, ~100€ each on amazon (including Tax and spedition)



