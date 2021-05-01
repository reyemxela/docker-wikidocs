FROM alpine:3

RUN apk add --no-cache \
    apache2 \
    php7 \
    php7-apache2 \
    php7-session \
    php7-mbstring \
    php7-json \
    shadow \
    curl

# enable rewrite module and allow .htaccess overrides
RUN sed -i "s/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/" /etc/apache2/httpd.conf && \
    printf "\n<Directory \"/var/www/localhost/htdocs\">\n\tAllowOverride All\n</Directory>\n" >> /etc/apache2/httpd.conf && \
    rm -f /var/www/localhost/htdocs/index.html

# download and extract wikidocs archive
RUN curl -Lso wikidocs.tar.gz https://github.com/Zavy86/WikiDocs/archive/master.tar.gz && \
    tar --strip-components=1 -xf wikidocs.tar.gz -C /var/www/localhost/htdocs/ && \
    rm wikidocs.tar.gz && \
    ln -s /var/www/localhost/htdocs/documents /

# start script to override apache user's uid/gid
RUN echo -e \
'#!/bin/sh\n'\
'groupmod -o -g ${PGID:-1000} apache\n'\
'usermod -o -u ${PUID:-1000} apache\n'\
'chown -R apache:apache /var/www/localhost/htdocs\n'\
'exec httpd -D FOREGROUND' > /start.sh
RUN chmod +x /start.sh

WORKDIR /var/www/localhost/htdocs
EXPOSE 80
VOLUME /documents

ENTRYPOINT ["/start.sh"]
