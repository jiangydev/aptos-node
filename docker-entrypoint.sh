#!/bin/bash

wget -O /opt/aptos/etc/genesis.blob https://devnet.aptoslabs.com/genesis.blob

wget -O /opt/aptos/etc/aypoint.txt https://devnet.aptoslabs.com/waypoint.txt

wget -O /opt/aptos/etc/node.yaml https://raw.githubusercontent.com/aptos-labs/aptos-core/main/docker/compose/public_full_node/public_full_node.yaml

wget -O /opt/aptos/etc/seeds.yaml https://raw.githubusercontent.com/jiangydev/aptos-node/main/seeds.yaml \
    && yq ea -i 'select(fileIndex==0).full_node_networks[0].seeds = select(fileIndex==1).seeds | select(fileIndex==0)' node.yaml seeds.yaml

if [ ! -z "$PRIVATE_KEY" -a ! -z "$PEER_ID" ]; then
  echo "已设置 Private Key 和 Peer ID"
  /usr/local/bin/yq -i '.full_node_networks[] +=  { "identity": {"type": "from_config", "key": "'$PRIVATE_KEY'", "peer_id": "'$PEER_ID'"} }' /opt/aptos/etc/node.yaml
else
  echo "未设置 Private Key 和 Peer ID，不影响运行。"
fi

/opt/aptos/bin/aptos-node -f /opt/aptos/etc/node.yaml
