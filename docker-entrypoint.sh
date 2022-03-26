#!/bin/bash

if [ ! -z "$PRIVATE_KEY" -a ! -z "$PEER_ID" ]; then
  echo "已设置 Private Key 和 Peer ID"
  /usr/local/bin/yq -i '.full_node_networks[] +=  { "identity": {"type": "from_config", "key": "'$PRIVATE_KEY'", "peer_id": "'$PEER_ID'"} }' /opt/aptos/etc/node.yaml
else
  echo "未设置 Private Key 和 Peer ID，不影响运行。"
fi

/opt/aptos/bin/aptos-node -f /opt/aptos/etc/node.yaml
