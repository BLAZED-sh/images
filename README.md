# blazed.sh Images

Docker images for use with [blazed.sh](https://blazed.sh).

## Available Images

### debian

A Debian-based workspace with an Ethereum node socket mounted at `/tmp/sockets/eth_rpc.sock`.

**Features:**
- Fish shell (default)
- SSH server with password auth and pubkey support
- Pre-installed: vim, curl, wget, git, python3, nodejs, htop, socat, jq
- Login banner showing Ethereum node stats (block height, gas price, peers)

**Usage:**
```bash
docker run -d \
  -e SSH_AUTHORIZED_KEY="ssh-rsa AAAA..." \
  -v /path/to/eth_rpc.sock:/tmp/sockets/eth_rpc.sock \
  -p 2222:22 \
  ghcr.io/blazed-sh/images/debian:sha-e286715
```

Password is printed to container logs on first boot.
