#! /bin/env sh

darkhttpd $HOME/.me/http --no-listing --syslog --no-server-id --addr 127.0.0.1 --port 10500 $@
