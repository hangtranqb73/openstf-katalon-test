#!/bin/ash
set -e
cd `dirname $0`

cp -p /ssh/host_keys/ssh_host_*_key* /etc/ssh/

cp -p /ssh/sshd_config /etc/ssh/

SSH_DIR='/home/ssh/.ssh'
if [ ! -e $SSH_DIR ]; then
  mkdir $SSH_DIR
  chmod 700 $SSH_DIR
fi
AUTH_KEYS_FILE="${SSH_DIR}/authorized_keys"
cat /ssh/authorized_keys/*.pub > $AUTH_KEYS_FILE
chmod 600 $AUTH_KEYS_FILE

sudo /usr/sbin/sshd -D -E /ssh/log

