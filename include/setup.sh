#!/bin/bash

compose=$(docker inspect --format '{{.Config.Labels}}' $(hostname) | grep -o -E 'com.docker.compose.project:[^ ]+' | awk -F: '{print $2}')
defaultInstance=""

if [ $compose != "" ]; then
  compose=${compose}_
  defaultInstance="_1"
fi

for i in $expose; do
  name=${compose}$(echo $i | awk -F: '{print $1}')${defaultInstance}
  port=$(echo $i | awk -F: '{print $2}')
  ip=$(docker inspect --format '{{.NetworkSettings.IPAddress}}' ${compose}${name}${defaultInstance})
  # make configuration file, but do not reload nginx until all files are created
  reset_connection "$name" "$port" "$ip" NORELOAD
done

if [ $(ps -ef | grep -c nginx) > 1 ]; then
  # if nginx is running, relaod the configuration
  nginx -s reload && echo nginx reloaded
fi

echo Setup Done
