#!/bin/bash
ZADDR=$(verus -testnet -chain=chips777 z_getnewaddress)
verus -chain=chips777 sendcurrency "*" '[{"amount":0, "address":"'$ZADDR'","data":{"filename":"/root/.verustest/pbaas/f42319bc427f4633d987bae4ebfdaeda41a56517/manorig.png"}}]'
