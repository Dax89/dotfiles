#!/bin/env bash

cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd

python -m http.server 8080 --bind 127.0.0.1
