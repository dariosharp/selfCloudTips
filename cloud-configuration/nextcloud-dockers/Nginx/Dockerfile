FROM nginx

RUN apt update

COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/robots.txt /var/www/html/robots.txt
COPY ./config/includes/ /etc/nginx/includes/
COPY ./config/backend-not-found.html /var/www/html/backend-not-found.html
COPY ./config/backend-not-found.html /etc/nginx/html/backend-not-found.html
