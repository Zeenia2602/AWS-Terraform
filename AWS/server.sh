#!/bin/bash
#Instanlling docker
#sudo apt-get remove docker docker-enginer docker.io -y
sudo apt-get update -y
sudo apt-get install nginx -y
sudo cat <<- EOF >>/etc/nginx/nginx.conf
stream {
  map $ssl_preread_server_name $targetBackend {
     default $ssl_preread_server_name;
 }

 server {
   listen 9092;

   proxy_connect_timeout 1s;
   proxy_timeout 7200s;

   resolver 127.0.0.53;

   proxy_pass $targetBackend:9092;
   ssl_preread on;
 }

 server {
   listen 443;

   proxy_connect_timeout 1s;
   proxy_timeout 7200s;

   resolver 127.0.0.53;

   proxy_pass $targetBackend:443;
   ssl_preread on;
 }

 log_format stream_routing '[$time_local] remote address $remote_addr'
                    'with SNI name "$ssl_preread_server_name" '
                    'proxied to "$upstream_addr" '
                    '$protocol $status $bytes_sent $bytes_received '
                    '$session_time';
 access_log /var/log/nginx/stream-access.log stream_routing;
}
EOF

sudo systemctl restart nginx
