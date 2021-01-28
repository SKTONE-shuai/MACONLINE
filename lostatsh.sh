#!/bin/bash

soft_dir=/usr/local/software/
cd $soft_dir
tar -zxf logstash-7.6.2.tar.gz
mv logstash-7.6.2 /usr/local/logstash

cat>>/usr/local/logstash/config/01-syslog.conf<<EOF
input {
    beats {
        port => "5044"
        }
    }
output {
    elasticsearch {
        hosts => "192.168.116.120:9200"
    }
    stdout { codec => rubydebug }
}
EOF
nohup /usr/local/logstash/bin/logstash -f /usr/local/logstash/config/01-syslog.conf & >/dev/null
netstat -lntp |grep 9600
