#!/bin/bash

SOCKET="/tmp/sockets/eth_rpc.sock"

rpc_call() {
    timeout 5 bash -c "echo '{\"jsonrpc\":\"2.0\",\"method\":\"$1\",\"params\":[],\"id\":1}' | \
        socat -t 2 - UNIX-CONNECT:$SOCKET" 2>/dev/null | jq -r '.result // "N/A"' || echo "N/A"
}

# Fetch data (each call has 5s timeout)
BLOCK_HEX=$(rpc_call "eth_blockNumber")
GAS_HEX=$(rpc_call "eth_gasPrice")
PEERS_HEX=$(rpc_call "net_peerCount")

# Convert hex to decimal (handle N/A)
hex_to_dec() {
    if [ "$1" = "N/A" ] || [ -z "$1" ]; then
        echo "N/A"
    else
        printf "%d" "$1" 2>/dev/null || echo "N/A"
    fi
}

BLOCK=$(hex_to_dec "$BLOCK_HEX")
GAS_WEI=$(hex_to_dec "$GAS_HEX")
PEERS=$(hex_to_dec "$PEERS_HEX")

# Convert gas to Gwei
if [ "$GAS_WEI" != "N/A" ]; then
    GAS_GWEI=$(echo "scale=2; $GAS_WEI / 1000000000" | bc 2>/dev/null || echo "N/A")
else
    GAS_GWEI="N/A"
fi

# Output MOTD to stdout
cat /usr/local/share/logo.txt

cat << EOF
  Ethereum Node Status
  -----------------------------------------------------
  Latest Block:  $BLOCK
  Gas Price:     $GAS_GWEI Gwei
  Peers:         $PEERS
  -----------------------------------------------------
  Socket: /tmp/sockets/eth_rpc.sock

EOF
