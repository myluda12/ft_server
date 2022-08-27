FROM debian:buster

EXPOSE 80 443

RUN cat

RUN apt update
RUN apt -y install nginx
RUN apt -y install vim
RUN apt -y install wget

RUN apt-get install wget -y
RUN apt-get install lsb-release -y
RUN apt-get install gnupg -y

COPY srcs/wordpress.sql /var

#COPY srcs/default /etc/nginx/sites-available/default


RUN apt-get install -y -qq php7.3-fpm php7.3-mysql php7.3-mbstring php-fpm 

##RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-all-languages.zip
RUN apt install unzip -y
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-all-languages.zip
RUN unzip *.zip
RUN cp -rf phpMyAdmin-5.0.1-all-languages /var/www/html
RUN mv /var/www/html/phpMyAdmin-5.0.1-all-languages /var/www/html/phpmyadmin
RUN chown -R www-data:www-data /var/www/html/phpmyadmin/



##wordpress
RUN wget -c https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz
RUN mv wordpress/ /var/www/html/
#COPY srcs/wordpress.sql /
#RUN rm /var/www/html/wordpress/wp-config-sample.php
RUN chown -R www-data:www-data /var/www/html/wordpress/
RUN chown -R www-data:www-data /var/www/html/
RUN chmod 755 -R /var/www/html/wordpress/
COPY srcs/wp-config.php /var/www/html/wordpress
#RUN bash -c "rm -f /var/www/html/wordpress/wp-config-sample.php"



RUN rm -rf /etc/nginx/sites-available/default
COPY srcs/default /etc/nginx/sites-available
RUN apt-get install -y -qq php7.3-fpm php7.3-mysql php7.3-mbstring php-fpm
RUN mv /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php
COPY  srcs/config.inc.php /var/www/html/phpmyadmin/config.inc.php

# MYSQL INSTALLATION
COPY srcs/install_mysql.sh .
RUN bash -c "bash install_mysql.sh"
#MYSQL CONFIG
COPY srcs/my_sql_conf.sh .
RUN bash -c "bash my_sql_conf.sh"




COPY srcs/config-ssl.sh .
RUN bash -c "bash config-ssl.sh"


RUN bash -c "rm -rf /etc/nginx/sites-enabled/default"
RUN bash -c "ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/"

COPY srcs/services.sh /
ENTRYPOINT [ "sh", "services.sh" ]

