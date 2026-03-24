#!/bin/bash
set -e

# Show logo on container start
cat /usr/local/share/logo.txt

echo "==========================================="
echo "  SSH User: user"

# Generate random password for user
PASSWORD=$(pwgen -s 16 1)
echo "user:$PASSWORD" | chpasswd
echo "  Password: $PASSWORD"

# Add SSH authorized key if provided
if [ -n "$SSH_AUTHORIZED_KEY" ]; then
    echo "$SSH_AUTHORIZED_KEY" > /home/user/.ssh/authorized_keys
    chown user:user /home/user/.ssh/authorized_keys
    chmod 600 /home/user/.ssh/authorized_keys
    echo "==========================================="
    echo "  SSH Public Key:"
    echo ""
    # Prettify the SSH key
    KEY_TYPE=$(echo "$SSH_AUTHORIZED_KEY" | awk '{print $1}')
    KEY_COMMENT=$(echo "$SSH_AUTHORIZED_KEY" | awk '{print $3}')
    KEY_FINGERPRINT=$(ssh-keygen -lf /home/user/.ssh/authorized_keys 2>/dev/null | awk '{print $2}')
    KEY_BITS=$(ssh-keygen -lf /home/user/.ssh/authorized_keys 2>/dev/null | awk '{print $1}')
    echo "  Type:        $KEY_TYPE"
    echo "  Bits:        $KEY_BITS"
    echo "  Fingerprint: $KEY_FINGERPRINT"
    if [ -n "$KEY_COMMENT" ]; then
        echo "  Comment:     $KEY_COMMENT"
    fi
fi

echo "==========================================="
echo ""

# Generate fresh SSH host keys on first boot
ssh-keygen -A

exec "$@"
