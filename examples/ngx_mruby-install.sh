#!/bin/bash 

# The script is generated from a Dockerfile via Dockerfile2bash(v0.1.0)
# By B1nj0y <idegorepl@gmail.com>

# The original Dockerfile is from a base image: <ubuntu:14.04> 

apt-get -y update
apt-get -y install sudo openssh-server
apt-get -y install git
apt-get -y install curl
apt-get -y install rake
apt-get -y install ruby2.0 ruby2.0-dev
apt-get -y install bison
apt-get -y install libcurl4-openssl-dev
apt-get -y install libhiredis-dev
apt-get -y install libmarkdown2-dev
apt-get -y install libcap-dev
apt-get -y install libcgroup-dev
apt-get -y install make
apt-get -y install libpcre3 libpcre3-dev
apt-get -y install libmysqlclient-dev
cd /usr/local/src/ && git clone https://github.com/matsumotory/ngx_mruby.git
export NGINX_CONFIG_OPT_ENV --with-http_stub_status_module --with-http_ssl_module --prefix=/usr/local/nginx --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module
echo "export NGINX_CONFIG_OPT_ENV --with-http_stub_status_module --with-http_ssl_module --prefix=/usr/local/nginx --with-http_realip_module --with-http_addition_module --with-http_sub_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module" >> ~/.bashrc
cd /usr/local/src/ngx_mruby && sh build.sh && make install
