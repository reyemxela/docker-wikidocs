FROM php:7-apache

# enable rewrite module and remove the "DirectoryIndex disabled" line from apache config
RUN a2enmod rewrite && \
    sed -i 's/DirectoryIndex disabled//' /etc/apache2/conf-enabled/docker-php.conf

# download and extract wikidocs archive
RUN curl -Lso wikidocs.tar.gz https://github.com/Zavy86/WikiDocs/archive/master.tar.gz && \
    tar --strip-components=1 -xf wikidocs.tar.gz -C /var/www/html/ && \
    rm wikidocs.tar.gz && \
    ln -s /var/www/html/documents /

# start script to override www-data user's uid/gid
RUN echo \
'#!/bin/bash\n'\
'groupmod -o -g ${PGID:-1000} www-data\n'\
'usermod -o -u ${PUID:-1000} www-data\n'\
'chown -R www-data:www-data /var/www/html\n'\
'exec apache2-foreground' > /start.sh
RUN chmod +x /start.sh

WORKDIR /var/www/html
EXPOSE 80
VOLUME /documents

ENTRYPOINT ["/start.sh"]
