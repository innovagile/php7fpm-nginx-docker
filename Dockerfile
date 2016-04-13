FROM phusion/baseimage
MAINTAINER innovagile <hello@innovagile.com>

RUN apt-get -y update
RUN apt-get install -y language-pack-en-base
RUN locale-gen en_US.UTF-8 && export LANG=en_US.UTF-8
RUN DEBIAN_FRONTEND=noninteractive LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get -y update
RUN apt-get -y upgrade

RUN apt-get install -y --force-yes php7.0-fpm php7.0-curl php7.0-cli php7.0-common php7.0-json php7.0-opcache php7.0-mysql php7.0-intl php-apcu openssl nginx
RUN apt-get autoremove -y

RUN mkdir -p /var/www
ADD www/public /var/www/public/

RUN apt-get autoremove -y
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /etc/my_init.d
ADD conf/my_init.d /etc/my_init.d/
RUN chmod +x /etc/my_init.d/*.sh

RUN mkdir -p /etc/service/nginx /run/nginx/cache /run/nginx/proxy
ADD services/nginx.sh /etc/service/nginx/run

RUN mkdir -p /etc/service/php-fpm /run/php
ADD services/php-fpm.sh /etc/service/php-fpm/run

RUN chmod +x /etc/service/*/run

RUN rm -fr /etc/nginx
ADD conf/nginx /etc/nginx/

COPY conf/php-fpm/php-fpm.conf /etc/php/7.0/fpm/php-fpm.conf

EXPOSE 80

CMD ["/sbin/my_init"]
