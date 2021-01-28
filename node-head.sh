#!/bin/bash

#安装node环境
tar -zxvf /root/elk/node-v11.8.0-linux-x64.tar.gz  -C /usr/local/

echo -e export NODEJS_HOME=/usr/local/node-v11.8.0-linux-x64 >> /etc/profile
echo -e 'export PATH=$PATH:$NODEJS_HOME/bin' >> /etc/profile
source /etc/profile
node -v
npm -v

#安装head插件
cd /root/elk
unzip elasticsearch-head-master.zip
mv elasticsearch-head-master /usr/local/

#修改配置一
cd /usr/local/
echo -e  http.cors.enabled: true >> elasticsearch-7.6.2/config/elasticsearch.yml
echo -e  http.cors.allow-origin: '"*"' >> elasticsearch-7.6.2/config/elasticsearch.yml
echo -e  node.master: true  >> elasticsearch-7.6.2/config/elasticsearch.yml
echo -e  node.data: true >> elasticsearch-7.6.2/config/elasticsearch.yml
cd /root/
#修改配置二
sed -i 's/localhost/192.168.30.31/g' /usr/local/elasticsearch-head-master/_site/app.js
sed -i 'N;98 a hostname:"*",'  /usr/local/elasticsearch-head-master/Gruntfile.js

source /etc/profile
#安装 
cd /usr/local/elasticsearch-head-master/
npm install -g grunt --registry=https://registry.npm.taobao.org
npm install -g cnpm --registry=https://registry.npm.taobao.org
cnpm install
grunt server &
