#!/bin/bash
getent passwd sshd
if [ $? -ne 0 ]; then
    install -vdm700 /var/lib/sshd &&
    chown -v root:sys /var/lib/sshd &&
    groupadd -g 50 sshd &&
    useradd -c 'sshd PrivSep' \
            -d /var/lib/sshd \
            -g sshd \
            -s /bin/false \
            -u 50 sshd &&
    ssh-keygen -A &&
    systemctl enable sshd.service
fi
