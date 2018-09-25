FROM alpine

RUN apk add --no-cache openssh

RUN apk add --no-cache sudo

# Avoid root login
RUN adduser -D ssh && echo "ssh:$(mkpasswd dummy)" | chpasswd # We can't SSH login to empty password users
RUN echo 'ssh ALL=NOPASSWD: /usr/sbin/sshd' >> /etc/sudoers
RUN addgroup root ssh && addgroup sshd ssh
RUN chgrp ssh /etc/ssh && chmod g+w /etc/ssh # For copy setting files
USER ssh

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-E", "/var/log/secure"]

