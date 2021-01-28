#!/bin/sh

#安装elasticsearch
tar -zxvf /root/elk/elasticsearch-7.6.2-linux-x86_64.tar.gz -C /usr/local/
#安装ik解析器
mv /root/elk/elasticsearch-analysis-ik-7.6.2.zip  /usr/local/elasticsearch-7.6.2/plugins/
cd /usr/local/elasticsearch-7.6.2/plugins/
unzip elasticsearch-analysis-ik-7.6.2.zip  -d analysis
mv elasticsearch-analysis-ik-7.6.2.zip  /root/elk/

cd /usr/local/elasticsearch-7.6.2/

#新建data目录：
mkdir data

cd config/
echo -e cluster.name: my-application >> elasticsearch.yml
echo -e node.name: node-1 >> elasticsearch.yml
echo -e path.data: /usr/local/elasticsearch-7.6.2/data >> elasticsearch.yml
echo -e path.logs: /usr/local/elasticsearch-7.6.2/logs >> elasticsearch.yml 
echo -e network.host: 0.0.0.0  >> elasticsearch.yml
echo -e http.port: 9200 >> elasticsearch.yml
echo -e cluster.initial_master_nodes: '["node-1"]' >> elasticsearch.yml

sed -i 's/Xms1g/Xms200m/g' jvm.options
sed -i 's/Xmx1g/Xmx200m/g' jvm.options

cd /root/
#创建用户
useradd esroot 
chown -R esroot.esroot /usr/local/elasticsearch-7.6.2/

#编辑limits.conf
echo -e esroot nofile 65536 >> /etc/security/limits.conf
echo -e esroot hard nofile 65536 >> /etc/security/limits.conf
echo -e esroot soft nproc 4096 >> /etc/security/limits.conf
echo -e esroot hard nproc 4096 >> /etc/security/limits.conf


echo -e esroot    soft    nproc   4096 >> /etc/security/limits.d/esroot-nproc.conf
echo -e root      soft    nproc   unlimited >> /etc/security/limits.d/esroot-nproc.conf
#编辑sysctl.conf
echo -e vm.max_map_count = 655360 >> /etc/sysctl.conf
sysctl -p

cd /usr/local/elasticsearch-7.6.2/
su - esroot -c "exec /usr/local/elasticsearch-7.6.2/bin/elasticsearch -d"
