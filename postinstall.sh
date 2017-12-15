#!/bin/bash
getent passwd sshd
if [ ! $? -eq 0 ]; then
    install -v -m700 -d /var/lib/sshd
    chown -v root:sys /var/lib/sshd
    groupadd -g 50 sshd
    useradd -c 'sshd PrivSep' \
            -d /var/lib/sshd \
            -g sshd \
            -s /bin/false \
            -u 50 sshd
fi
ssh-keygen -A
systemctl enable sshd.service
