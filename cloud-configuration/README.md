# Cloud Configuration
My cloud solution is composed of Nextcloud and Nginx for managing the application interface, Docker for managing applications easily, efficiently, and securely, and the combination of Ansible and Git for additional reliability. I chose to remove CasaOS from my Zimaboard and install Debian Stable to have full control over what is installed on the device.

# TOC
 - Cloud solutions comparison
 - NextCloud configuration
 - How to expose on the internet the cloud
 - Hardening

# Cloud solutions comparison
There are multiple applications for cloud interfacing. Most of them are very new and not completely mature but have potential. The most common applications are Nextcloud, Immich, PhotoPrism, and Piwigo.
- Nextcloud (https://nextcloud.com) is a cloud storage and collaboration platform that provides a wide range of functionality similar to commercial services like Google Drive or Microsoft OneDrive. It is well-designed for data protection, providing multiple encryption features. For example, it allows data to be encrypted per user, meaning that all files uploaded by a user are encrypted with their login password. Nextcloud can also be used for managing photos similarly to Google Photos or Apple iCloud. The web extension and the mobile application called "Memories" are very user-friendly and well-developed. Moreover, Nextcloud is stable, easy to update, and can be easily handled using Docker. Nextcloud also has a desktop application that automatically syncs directories. Overall, Nextcloud is a comprehensive, 360-degree cloud application.
- Immich (https://immich.app) is an open-source, self-hosted photo and video backup solution specifically designed to provide users with an alternative to services like Google Photos and Apple iCloud Photos. It is a relatively new project; thus, the mobile application does not properly upload images automatically when the application is in the background. Immich is well integrated with object recognition, which automatically detects objects and faces in images.
- PhotoPrism (https://www.photoprism.app) is an AI-powered photo management application that helps users organize, browse, and share their personal photo and video collections. It is designed to be a self-hosted alternative to commercial services like Google Photos, offering privacy, advanced search capabilities, and powerful AI-based features for tagging and organizing photos.
- Piwigo (https://piwigo.org) is a web-based photo gallery application designed for managing, organizing, and sharing photos and videos. It is a flexible and feature-rich platform that can be self-hosted on various types of servers, making it a popular choice for individuals, photographers, organizations, and businesses looking to have full control over their media libraries.
   
## Why NextCloud?
Nextcloud is very stable and has a visually appealing interface. The "Memories" application is very nice and offers a user experience similar to Google Photos. Personally, I prefer the UI of Nextcloud and Immich compared to PhotoPrism and Piwigo. However, Immich is still in its early stages; the mobile application does not automatically upload photos when running in the background, forcing users to constantly remember to open the app to start the photo upload process. In contrast, the Nextcloud app automatically uploads images in the background. Additionally, Nextcloud allows the upload of arbitrary files and can be used for collaborative environments.

<div align="center">
<img src="https://github.com/user-attachments/assets/c3577dba-a823-40bc-9805-79d246b62d02" alt="software" width="800" height="450">
<p><b>The web application</b></p>
</div>

# NextCloud configuration
There are multiple ways to install and use NextCloud, my solution is based on Docker. Docke is very powerfull tool that allows me to segragate in multiple safaty containers the various applications. Moreover, each container has the minimum packets to allow the application to run, creating a very powerfull, light and safe environment. Here you can find the nextcloud documentatation to run the application in docker: [NextCloud Documentation](https://docs.nextcloud.com/server/latest/admin_manual/office/example-docker.html). 

## Docker containers
My configuration is composed by three different containers, the NextCloud application, the database and Nginx.
1. NextCloud container, as the name suggest, contains the NextCloud application.
2. The database container, as the name suggest, contains the mariadb database, used by NextCloud to handle all the information.
3. Nginx, instead the reverse proxy. Nginx is very powerfull and light reverse proxy, which allows to handle HTTPS, HTTP2 or 3 and subdomains. It is also able to log all the HTTP requests and combined with fail2ban can increase the security of the cloud.

Here you can find the nextcloud configuration [NextCloud Docker Configuration](https://github.com/dariosharp/selfCloudTips/tree/main/cloud-configuration/nextcloud-dockers). 

### NextCloud container
The NextCloud container aimd to handle the NextCloud application and configuration. This include where to store the data, handling the resourses, configure the communication with the databese and Nginx.
In order to let the RAID works properly and save the data in case of HD failure is required to set the data path in the correct location. By using the tag `volumes` in docker configuration file it is possible to share directories between the host and the containers. The sensitive data are stored in the folders under the path `/var/www/html/`, below is reported the configration example. 
```
volumes:
- ${NEXTCLOUD}/nextcloud/apps:/var/www/html/apps
- ${NEXTCLOUD}/nextcloud/config:/var/www/html/config
- ${NEXTCLOUD}/nextcloud/custom_apps:/var/www/html/custom_apps
- ${NEXTCLOUD}/nextcloud/data:/var/www/html/data
- ${NEXTCLOUD}/nextcloud/themes:/var/www/html/themes
```

It is very important also to properly set the environemtal variable to communicate with mariadb and nginx:
```
    environment:
      - VIRTUAL_HOST=storage.my_personal_cloud.com
      - OVERWRITEPROTOCOL=https
      - MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
      - MYSQL_PASSWORD=${MYSQL_PASSWORD}
      - MYSQL_DATABASE=${MYSQL_DATABASE}
      - MYSQL_USER=${MYSQL_USER}
      - MYSQL_HOST=mariadb-server:3306
      - TRUSTED_PROXIES=nginx-server
      - PHP_MEMORY_LIMIT=2G
```

### NGINX Container
The Nginx container is perhaps the most critical one, as it handles nearly all security features, including encryption. My Nginx configuration can be found [here](https://github.com/dariosharp/selfCloudTips/blob/main/cloud-configuration/nextcloud-dockers/Nginx/config/nginx.conf); it supports HTTP/2, HTTPS, and includes the headers necessary for security.

```
    ports:
      - 443:443
      - 80:80
    build: ./Nginx
    volumes:
      - ${LOGS}/nginx:/var/log/nginx/
      - ${SSL}:/etc/letsencrypt:ro
    restart: unless-stopped
```

#### HTTPS & HTTP/2
**HTTPS** is essential if you want to expose a web application, as it ensures both security and efficiency. By encrypting data transmitted between the client and server, HTTPS helps protect sensitive information from interception or tampering. It also enables features like HTTP/2, which can improve performance through faster data transfer and reduced load times. In today’s online environment, HTTPS is a standard requirement for maintaining user trust and meeting security best practices.

To properly create the certificate, I used **Let's Encrypt**, which is free and integrates easily with Nginx. Let's Encrypt provides detailed documentation [here](https://letsencrypt.org/), making it simple to understand and set up.

I also used **Certbot for Nginx**, which automates the creation and renewal of certificates, ensuring they stay up-to-date with minimal effort. You can find Certbot instructions [here](https://certbot.eff.org/instructions?ws=nginx&os=pip).

Once the certificates have been created, they need to be shared with the Nginx container. Certbot typically creates the certificates under the path `/etc/letsencrypt`. Using Docker volumes, it is possible to grant the container access to the created certificates.

**HTTP/2** uses HPACK, a header compression algorithm that minimizes the overhead associated with HTTP headers, particularly for repeated headers across requests. Generally, HTTP/2 can be 2–3 times faster than HTTP/1.1. The combination of HTTPS and HTTP/2 protocols significantly enhances both the security and speed of the cloud.


#### Logs
Nginx can be used to monitor network activities and check the system's status. Logs can be integrated with Fail2ban to automatically ban malicious users and bots. Since Nginx periodically stores logs, I do not store them on the RAID HDD. Instead, I purchased an external 64GB USB drive to store and monitor the data.





