#!/bin/sh
free -h --giga | awk '/Mem:/{print $3}'
