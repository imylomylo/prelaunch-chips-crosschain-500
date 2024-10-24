#!/bin/bash
START=$PWD
source network.txt
ln -sf list.${network}.json list.json


### FUNDER
funder=100
echo "Getting the last index of list.json for FUNDER_NODE_RADDRESS"
FUNDER_RADDRESS=$(cat list.json | jq -r ".[$funder][3]")
FUNDER_PUBKEY=$(cat list.json | jq -r ".[$funder][1]")
echo "Funder raddress is: ${FUNDER_RADDRESS}"
echo "Funder  pubkey is: ${FUNDER_PUBKEY}"
sleep 1
#########################################

### number of clones to make
CLONES=$1
echo "Making ${CLONES} on ${network}"

if [ "${last_created}" == "directory" ] ; then
	echo "Last created = Using directory strategy"
	LAST_CREATED=$(ls -1dr instance* 2>/dev/null | grep instance | head -n 1 | cut -d '-' -f 2)
fi

# sanity check 
if [ -z $LAST_CREATED ] ; then
	LAST_CREATED=99
fi

echo ${LAST_CREATED}

# start loop to create instances
for (( i = 0 ; i < $CLONES ; i++ ))
do
    cd $START
    # add 100, this forms the octet for network segregation e.g. 172.XXX.0.0/16
    # OR
    # add 100, this forms the octet for host ip e.g. 172.77.0.XXX/16
    CLONE=$((100 + i))
    echo "Next in clone instance is $CLONE, last created before this script execution was $LAST_CREATED"
    sleep 1
    # check if this iteration is greater than the last known created instance (helpful at the start or when re-running to make more)
    echo $CLONE ">" $LAST_CREATED "?"
    if [ "$CLONE" -gt "$LAST_CREATED" ] ; then 
	# name of this instance 
        INSTANCE=instance-$CLONE
	# make working dir for this instance organization and link stuff required
        mkdir $INSTANCE
	# TODO link the sending tx code project
	# ln -sf -t $INSTANCE ./blast-helper-crosschain-prelaunch-chips
	mkdir $INSTANCE/data_dir
	cp clone.prelaunch_chips.docker-compose.yaml $INSTANCE/docker-compose.yaml
	cp clone.prelaunch_chips.env $INSTANCE/.env
	THIS_CLONE_PUBKEY=$(cat list.json | jq -r ".[$i][1]")
        THIS_CLONE_WIF=$(cat list.json | jq -r ".[$i][2]")
        THIS_CLONE_RADDRESS=$(cat list.json | jq -r ".[$i][3]")
        echo "CLONE $CLONE create docker-compose (yaml & env)"
	# sed replace template vars with this instance vars
        sed -i "s/XX_CLONE_XX/$CLONE/g" $INSTANCE/.env
        sed -i "s/XX_CLONE_XX/$CLONE/g" $INSTANCE/docker-compose.yaml
        sed -i "s/XX_THIS_NODE_PUBKEY_XX/$THIS_CLONE_PUBKEY/g" $INSTANCE/.env
        sed -i "s/XX_THIS_NODE_WIF_XX/$THIS_CLONE_WIF/g" $INSTANCE/.env
        sed -i "s/XX_THIS_NODE_RADDRESS_XX/$THIS_CLONE_RADDRESS/g" $INSTANCE/.env

    else
    	echo "Try higher value, adding 1 to $CLONES"
	CLONES=$((CLONES + 1))
	echo "CLONES to try starting bumped up by 1, is now $CLONES"
	echo "Next try will be $((CLONE + i + 1))"
	sleep 1
    fi
done
