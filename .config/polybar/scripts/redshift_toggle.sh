#! /bin/sh

PID=$(pgrep -x redshift)

if [ $PID ]; then
    kill -9 $PID
    redshift -x
else
    redshift -v &
fi
