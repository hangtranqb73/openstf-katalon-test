#!/bin/bash

set -e
cd `dirname $0`

ADBKEY_PATH="$(pwd)/adbkey.pub"

if [ -e "$ADBKEY_PATH" ]; then
  echo -e "\e[32m Appium setup has alredy done \e[m"
  exit 0
fi

adb start-server
adb kill-server

cp -a /root/.android/adbkey.pub $ADBKEY_PATH

echo "ADB key is exported."
cat $ADBKEY_PATH
echo
echo -e "\e[31m Please add this to OpenSTF's ADB key list \e[m"

