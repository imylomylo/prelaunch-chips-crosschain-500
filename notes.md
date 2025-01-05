

1. add mit license to verusd docker
2. create prelaunch-chips-crosschain-500 repo with mit license

todo
add ansible stuff, relicense mit
add verus rpc python lib, relicense mit
new centralized control service or use verusid as oracle
new python script for generating transactions


docker-compose exec -i -t verusd.chips_118 verus -chain=chips -testnet getbalance


jan 4
previosly, clone.sh had been run `./clone.sh 5` to create 5 instances.

hammer_control.py uses sendcurrency with "*" as the sending address.
it is run from its own venv from the local machine (not in a container).
