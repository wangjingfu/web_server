#!/usr/bin/env bash

echo "Starting nginx server..."
nginx -g "daemon off;" &

echo "Starting php-fpm server..."
php-fpm &

echo "Starting redis server..."
redis-server /etc/redis/redis.conf --appendonly yes &

while true
 do sleep 1
done