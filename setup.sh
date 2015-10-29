#!/bin/bash

config="alpha:80 beta:80"
compose=$(docker inspect --format '{{.Config.Labels}}' $(hostname) | grep -o -E 'com.docker.compose.project:[^ ]+' | awk -F: '{print $2}')
defaultInstance=""

if [ $compose != "" ]; then
  compose=${compose}_
  defaultInstance="_1"
fi

for i in $expose; do
  name=$(echo $i | awk -F: '{print $1}')
  port=$(echo $i | awk -F: '{print $2}')
  ip=$(docker inspect --format '{{.NetworkSettings.IPAddress}}' ${compose}${name}${defaultInstance})
  echo $name $port $ip
  gen_nginx_conf $name http $ip $port > /etc/nginx/conf.d/${name}.conf
done

if [ $(ps -ef | grep -c nginx) > 1 ]; then
  # if nginx is running, relaod the configuration
  nginx -s reload && echo nginx reloaded
fi

echo Setup Done
