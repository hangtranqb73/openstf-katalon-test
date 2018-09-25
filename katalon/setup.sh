#!/bin/bash

set -e
cd `dirname $0`

docker-compose run --rm stf-portforwarder /root/setup.sh
docker-compose run --rm appium /scripts/setup.sh

docker-compose down

