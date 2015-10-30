#!/bin/bash

touch /var/log/secrettunnel
compose=$(docker inspect --format '{{.Config.Labels}}' $(hostname) | \
          grep -o -E 'com.docker.compose.project:[a-zA-Z0-9_-]+' | \
          awk -F: '{print $2}')
defaultInstance=""

if [ $compose != "" ]; then
  compose=${compose}_
  defaultInstance="_1"
fi

for i in $expose; do
  alias=$(echo $i | awk -F: '{print $1}')
  name=${compose}${alias}${defaultInstance}
  port=$(echo $i | awk -F: '{print $2}')
  ip=$(docker inspect --format '{{.NetworkSettings.IPAddress}}' $name)
  # make configuration file, but do not reload nginx until all files are created
  reset_connection "$name" "$port" "$alias" NORELOAD &
  spotter -addr="/var/run/docker.sock" -e="$name:start:reset_connection:$name:$port:$alias" &
done

if [ $(ps -ef | grep -c nginx) > 1 ]; then
  # if nginx is running, relaod the configuration
  nginx -s reload
fi

echo Setup Done
