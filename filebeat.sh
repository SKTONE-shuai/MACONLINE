#!/bin/bash

soft_dir="/usr/local/software"
cd $soft_dir
tar -xvf filebeat-7.6.2-linux-x86_64.tar.gz  
mv filebeat-7.6.2-linux-x86_64 /usr/local/filebeat

cat >/usr/local/filebeat/filebeat.yml<<EOF
filebeat.prospectors:
- input_type: log
  paths:
    - /var/log/*.log
output.logstash:
  hosts: ["192.168.116.120:5044"]
EOF
cd /usr/local/filebeat/
nohup /usr/local/filebeat/filebeat & >/dev/null
