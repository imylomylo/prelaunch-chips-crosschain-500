#!/bin/bash
source network.txt
# Set the from address and the currency and amount variables
FROM_ADDRESS=RLDmncLM7jom8PrMro5jofGzx3geejFSRh
CURRENCY="CHIPS"
AMOUNT=7.77
DAEMON_CLI=$daemon_cli

# Use jq to extract the addresses and format them as needed
addresses=$(jq -c '[.[] | {currency: "'$CURRENCY'", amount: '$AMOUNT', address: .[3]}]' ../list.json)

# Run the verus sendcurrency command with the generated JSON array
echo "$DAEMON_CLI sendcurrency \"$FROM_ADDRESS\" '$addresses'"
