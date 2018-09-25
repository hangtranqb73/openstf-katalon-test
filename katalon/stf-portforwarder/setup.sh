#!/bin/sh

set -e
cd `dirname $0`

SSH_DIR="$(pwd)/.ssh"
if [ ! -e "$SSH_DIR" ]; then
  mkdir $SSH_DIR
  chmod 700 $SSH_DIR
  ssh-keygen -t ed25519 -P "" -f "${SSH_DIR}/id.key" -C "SSH port forward client"
else
  echo -e "\e[32m STF-PortFowarder setup has alredy done \e[m"
  exit 0
fi

echo "SSH key is exported."
cat "${SSH_DIR}/id.key.pub"
echo
echo -e "\e[31m Please add this file to OpenSTF side sshd server's /ssh/authorized_keys/ \e[m"

