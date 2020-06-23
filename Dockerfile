FROM debian:9

RUN apt update
RUN apt install build-essential -y
RUN apt install apache2 php php-mbstring php-pgsql php-soap php-pear php-dev vim wget -y

# php xdebug
RUN pecl channel-update pecl.php.net
RUN pecl install xdebug-2.8.1
RUN echo "zend_extension=/usr/lib/php/20151012/xdebug.so" > /etc/php/7.0/apache2/conf.d/xdebug.ini \
&& echo "xdebug.remote_enable=1" >> /etc/php/7.0/apache2/conf.d/xdebug.ini \
&& echo "xdebug.remote_handler=dbgp" >> /etc/php/7.0/apache2/conf.d/xdebug.ini \
&& echo "xdebug.remote_mode=req" >> /etc/php/7.0/apache2/conf.d/xdebug.ini \
&& echo "xdebug.remote_host=host.docker.internal" >> /etc/php/7.0/apache2/conf.d/xdebug.ini \
&& echo "xdebug.remote_port=9000" >> /etc/php/7.0/apache2/conf.d/xdebug.ini \
&& echo "xdebug.remote_autostart=1" >> /etc/php/7.0/apache2/conf.d/xdebug.ini \
&& echo "xdebug.extended_info=1" >> /etc/php/7.0/apache2/conf.d/xdebug.ini \
&& echo "xdebug.remote_connect_back = 0" >> /etc/php/7.0/apache2/conf.d/xdebug.ini

# config httpd
RUN sed -i -- "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf \
&& sed -i -- "s/AllowOverride none/AllowOverride All/g" /etc/apache2/apache2.conf

# config php
RUN echo "date.timezone = America/Sao_Paulo" > /etc/php/7.0/apache2/conf.d/sistemas.ini \
&& echo "short_open_tag=On" >> /etc/php/7.0/apache2/conf.d/sistemas.ini \
&& echo "display_errors = On" >> /etc/php/7.0/apache2/conf.d/sistemas.ini \
&& echo "error_reporting = E_ALL & ~E_DEPRECATED & ~E_NOTICE" >> /etc/php/7.0/apache2/conf.d/sistemas.ini

WORKDIR /var/www/html
ADD . /var/www/html

EXPOSE 80