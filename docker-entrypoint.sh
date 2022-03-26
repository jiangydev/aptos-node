#!/bin/bash

wget -O /opt/aptos/etc/genesis.blob https://devnet.aptoslabs.com/genesis.blob

wget -O /opt/aptos/etc/waypoint.txt https://devnet.aptoslabs.com/waypoint.txt

wget -O /opt/aptos/etc/node.yaml http://static.aptos.movemove.org/aptos/public_full_node.yaml

wget -O /opt/aptos/etc/seeds.yaml http://static.aptos.movemove.org/aptos/seeds.yaml \
    && yq ea -i 'select(fileIndex==0).full_node_networks[0].seeds = select(fileIndex==1).seeds | select(fileIndex==0)' /opt/aptos/etc/node.yaml /opt/aptos/etc/seeds.yaml

if [ ! -z "$PRIVATE_KEY" -a ! -z "$PEER_ID" ]; then
  echo "已设置 Private Key 和 Peer ID"
  /usr/local/bin/yq -i '.full_node_networks[] +=  { "identity": {"type": "from_config", "key": "'$PRIVATE_KEY'", "peer_id": "'$PEER_ID'"} }' /opt/aptos/etc/node.yaml
else
  echo "未设置 Private Key 和 Peer ID，不影响运行。"
fi

/opt/aptos/bin/aptos-node -f /opt/aptos/etc/node.yaml
