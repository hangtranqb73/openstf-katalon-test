#!/bin/ash
set -e
cd `dirname $0`

secret_key_path=/root/.ssh/id.key
if [ ! -e $secret_key_path ]; then
  echo "SSH secret key does not exist: $secret_key_path" 1>&2
  exit 1
fi

/usr/bin/app

