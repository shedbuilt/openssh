#!/bin/bash
if [ ! -e /etc/ssh/ssh_config ]; then
    install -m644 /etc/ssh/ssh_config.default /etc/ssh/ssh_config
fi
if [ ! -e /etc/ssh/sshd_config ]; then
    install -m644 /etc/ssh/sshd_config.default /etc/ssh/sshd_config        
fi
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
    ssh-keygen -A
    systemctl enable sshd.service
fi
