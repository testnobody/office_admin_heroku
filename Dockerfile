FROM centos:7.0
RUN  yum install httpd php php-cli unzip php-gd php-mbstring -y
WORKDIR  /var/www/html
COPY ms365admin.zip /var/www/html/ms365admin.zip
RUN   unzip /var/www/html/ms365admin.zip
RUN   chmod -R 777 /var/www/html
COPY   init.sh /init.sh
RUN   systemctl start httpd.service
CMD ["/bin/bash","/init.sh"]
