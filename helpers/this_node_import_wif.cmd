#!/bin/bash
source .env
docker-compose exec -i -t verusd.chips_$CLONE verus -chain=chips -testnet importprivkey $THIS_NODE_WIF