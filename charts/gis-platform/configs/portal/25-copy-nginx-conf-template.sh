#!/bin/sh
# vim:sw=4:ts=4:et

set -e

if [ -f "/etc/nginx/nginx.conf.template" ]; then
    echo "Copying nginx.conf template"
    cp /etc/nginx/nginx.conf.template /etc/nginx/nginx.conf
fi
