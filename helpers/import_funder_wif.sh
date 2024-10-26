#!/bin/bash
FUNDER_WIF=$(jq -r '.[] | select(.[0] == 100) | .[2]' list.json)
FUNDER_PUBKEY=$(jq -r '.[] | select(.[0] == 100) | .[1]' list.json)
FUNDER_RADDRESS=$(jq -r '.[] | select(.[0] == 100) | .[3]' list.json)
echo $FUNDER_RADDRESS
docker-compose -f vrsctest.docker-compose.yaml exec verusd.vrsctest verus -chain=vrsctest validateaddress ${FUNDER_RADDRESS}
docker-compose -f vrsctest.docker-compose.yaml exec verusd.vrsctest verus -chain=vrsctest importprivkey ${FUNDER_WIF}
docker-compose -f vrsctest.docker-compose.yaml exec verusd.vrsctest verus -chain=vrsctest validateaddress ${FUNDER_RADDRESS}
