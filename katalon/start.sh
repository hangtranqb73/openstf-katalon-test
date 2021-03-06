#!/bin/bash

set -e
cd `dirname $0`

# .envがなかったら値を聞いて出力
if [ ! -e ".env" ]; then
  echo "There is not ./.env file. So you need to input the values..."
  printf "OpenSTF's hostname: "
  read host
  printf "OpenSTF's AccessToken: "
  read token
  printf "SSH port: "
  read port
  printf "DEST_HOST=${host}\nDEST_PORT=${port}\nSTF_ACCESS_TOKEN=${token}\n" > .env
fi

docker-compose up -d

