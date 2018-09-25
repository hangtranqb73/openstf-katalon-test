cd `dirname $0`

ls ./ssh/host_keys/ssh_host_* > /dev/null 2>&1
if [ $? -ne 0 ]; then
  docker-compose run -v "$(pwd)/ssh/host_keys":/etc/ssh sshd /usr/bin/ssh-keygen -A
fi

docker-compose up -d

