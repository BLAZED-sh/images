#!/bin/bash
set -e

# Generate random password for user
PASSWORD=$(pwgen -s 16 1)
echo "user:$PASSWORD" | chpasswd
echo "=== User password: $PASSWORD ==="

# Add SSH authorized key if provided
if [ -n "$SSH_AUTHORIZED_KEY" ]; then
    echo "$SSH_AUTHORIZED_KEY" > /home/user/.ssh/authorized_keys
    chown user:user /home/user/.ssh/authorized_keys
    chmod 600 /home/user/.ssh/authorized_keys
fi

# Initial MOTD update
/usr/local/bin/update-motd.sh

# Start cron for periodic MOTD updates
echo "* * * * * root /usr/local/bin/update-motd.sh" > /etc/cron.d/update-motd
chmod 644 /etc/cron.d/update-motd
cron

exec "$@"
