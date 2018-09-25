#!/bin/bash

set -e
cd `dirname $0`

function portforward {
  if [ "$1" = "clear" ]; then
    curl http://stf-portforwarder/clear --fail
    return $?
  fi

  port=$1
  if [ -z "$2" ]; then
    method="POST"
  else
    method="DELETE"
  fi

  curl http://stf-portforwarder/portforward -X $method -d "{\"port\":${1}}" --fail
}
portforward clear
portforward 7100

STF_INFO='stf-portforwarder:7100'

DEVICE_INFO=`node stf-connect.js $STF_INFO`
DEVICE_PORT=`cut -d':' -f 2 <<<"${DEVICE_INFO}"`
DEVICE_INFO="stf-portforwarder:${DEVICE_PORT}"
portforward $DEVICE_PORT

export ADBHOST=stf-portforwarder
export ANDROID_ADB_SERVER_PORT=$DEVICE_PORT

set +e
# the results of these commands seem to be failed but it's ok. sigh...
adb tcpip $DEVICE_PORT
adb connect $DEVICE_INFO
adb devices
set -e
timeout -sKILL 3 adb wait-for-device shell echo "OK"

function disconnectDevice {
  adb disconnect $DEVICE_INFO
  node stf-disconnect.js $STF_INFO
  portforward clear
}

trap disconnectDevice EXIT

appium --suppress-adb-kill-server

disconnectDevice

