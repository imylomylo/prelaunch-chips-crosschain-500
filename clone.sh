#!/bin/bash
START=$PWD
source network.txt
ln -sf list.${network}.json list.json


### FUNDER
funder=100
echo "Getting the last index of list.json for FUNDER_NODE_RADDRESS"
FUNDER_RADDRESS=$(cat list.json | jq -r ".[$funder][3]")
FUNDER_WIF=$(cat list.json | jq -r ".[$funder][2]")
FUNDER_PUBKEY=$(cat list.json | jq -r ".[$funder][1]")
sed -i "s/XX_THIS_NODE_PUBKEY_XX/$FUNDER_PUBKEY/g" .env
sed -i "s/XX_THIS_NODE_WIF_XX/$FUNDER_WIF/g" .env
sed -i "s/XX_THIS_NODE_RADDRESS_XX/$FUNDER_RADDRESS/g" .env
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
	if [ -f "chips777.bootstrap.tar" ]; then
		echo "Using bootstrap"
		sleep 1
		cd $INSTANCE/data_dir
		tar xvf ../../chips777.bootstrap.tar.gz
		cd $START
	fi
	# deprecated cp ./helpers/c1eeedeffdb8be0150af4873155b2b88a9146e0d.conf $INSTANCE/data_dir/
	cp ./helpers/f42319bc427f4633d987bae4ebfdaeda41a56517.conf $INSTANCE/data_dir/
	cp clone.prelaunch_chips.docker-compose.yaml $INSTANCE/docker-compose.yaml
	cp clone.prelaunch_chips.env $INSTANCE/.env
	ln -s -t $INSTANCE ../vrsctest.conf
	ln -s -t $INSTANCE  ../helpers/this_node_import_wif.cmd
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
	screen -dmS $INSTANCE bash -c "cd $INSTANCE; docker-compose --project-name $INSTANCE up; exec bash"
	echo "sleep for 5s"
	sleep 5


    else
    	echo "Try higher value, adding 1 to $CLONES"
	CLONES=$((CLONES + 1))
	echo "CLONES to try starting bumped up by 1, is now $CLONES"
	echo "Next try will be $((CLONE + 1))"
	sleep 0.2
    fi
done
