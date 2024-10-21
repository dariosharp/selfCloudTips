# My Journey in Cloud self-hosting

### Table Of Contents
- [Introduction](#introduction)
- [Hardware](hardware/README.md)
- [File-system](file-system/README.md)
- [Cloud configuration](cloud-configuration/README.md)

## Introduction
Creating a personal cloud is a long journey that requires a lot of time to research and determine which solution is best for you at the time of creation. I explored multiple technologies, both hardware and software, to build my homemade cloud device based on my requirements. I decided to share my journey to help those who want to explore cloud self-hosting. Essentially, this post is a guide for a younger version of myself who was looking for their own solution. If I had had access to a post like this, my path would have been much easier. Regardless, this journey has been very helpful in improving my skills and gaining an overview of a field that is not my own.

### Rationale
What I want to create is a family cloud where we can store photos and data with high reliability and integrity for 4 or 5 people. The data must be accessible from anywhere with a good user experience. Both web applications and mobile applications for Android and iOS should be available.
A very important point is security. No one should be able to access the system without authorization, not even the system administrator (me) should have access to other people's data.
Additionally, the device must be affordable and consume as little power as possible. 

### Consideration
This blog is not a step-by-step guide on how to create a self-hosted cloud. Instead, it’s about sharing my considerations and experiences with self-hosting, which might help you find the best solution for your own environment. My choices might not align with your needs or preferences. Through these experiments, I learned about many new technologies that are not commonly part of my daily routine. So, I may have made mistakes—I'm not a cloud developer, or even a developer at all.

### About me
I’m passionate about self-hosting and have a strong background in cybersecurity. With over 10 years of experience in the field, I have tested a wide range of applications from a cybersecurity perspective, covering everything from hardware to cloud-based solutions.

## Abstract
A home cloud can offer the privacy and customization that no other online solutions can provide. After a long journey, I decided to use a single-board computer with two 4TB HDDs configured in a mirrored setup. The cloud software is based on Nextcloud, and NAS capabilities are managed using the ZFS filesystem. Nextcloud is privacy-oriented, and ZFS is one of the most reliable filesystems available. Additionally, using Ansible increases the reliability of the setup.
<br>
<div align="center">
  <img src="https://github.com/user-attachments/assets/cb3f97ec-f006-44e5-897d-2acc8aada9a1" alt="hardware" width="450" height="430">
<p><b>The hardware</b></p>
</div>
<br>
<div align="center">
<img src="https://github.com/user-attachments/assets/87a44740-90fc-4202-872f-5123173a6182" alt="software" width="900" height="450">
<p><b>The web application</b></p>
</div>
<br>
<div align="center">
<img src="https://github.com/user-attachments/assets/c042980c-d090-4b56-bdb7-4a272bc7f08d" alt="moblie app" width="200" height="400">
<p><b>The Mobile Application</b></p>
</div>


