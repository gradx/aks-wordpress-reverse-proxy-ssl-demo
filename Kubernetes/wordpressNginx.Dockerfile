FROM bitnami/wordpress-nginx
USER root
RUN apt-get update && apt-get upgrade
RUN apt install nano
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    nano \
    sudo
#RUN sed -i '/server_tokens off;/aabsolute_redirect off;' /opt/bitnami/nginx/conf/nginx.conf
#RUN sed -i 's/https:\/\//https2:\/\//g' /opt/bitnami/wordpress/wp-config.php
USER 1001
