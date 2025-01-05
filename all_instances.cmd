#!/bin/bash
for i in `ls -d instance-1*`
#for i in `ls -d instance-10[1-9]`
#for i in `ls -d instance-11*`
#for i in `ls -d instance-12*`
do 
	cd $i
	CLONE=$(echo $i | cut -d - -f 2)
	echo $CLONE
	########
	#cd data_dir
	#tar xvf ../../chips777.bootstrap.tar
	#cd ..
	#####################################
	#cp /home/mylo/manorig.png data_dir/
	#cp ../helpers/upload_chips777.sh data_dir/
	######################################
	#docker-compose down
	#screen -S $i -X stuff "docker-compose start\n"
	screen -S $i -X stuff "docker-compose up\n"
	sleep 5
	######################################
	#sed -i 's/-testnet/-testnet -fastload -enablefileencryption/' docker-compose.yaml
	#cp ../helpers/c1eeedeffdb8be0150af4873155b2b88a9146e0d.conf .
	#mv -f c1eeedeffdb8be0150af4873155b2b88a9146e0d.conf data_dir/
	#docker-compose up -d
	#docker-compose stop
	#sudo tail -n 3  data_dir/debug.log
	#sudo rm -Rf data_dir/blocks data_dir/chainstate data_dir/komodostate* data_dir/notarisations
	#./import
	#docker-compose exec -i -t verusd.chips_$CLONE verus -chain=chips777 -testnet z_getnewaddress
	#docker-compose exec -i -t verusd.chips_$CLONE verus -chain=chips777 -testnet getconnectioncount
	#docker-compose exec -i -t verusd.chips_$CLONE verus -chain=chips777 -testnet listbanned
	docker-compose exec -i -t verusd.chips_$CLONE verus -chain=chips777 -testnet clearbanned
	# add nodes
	#docker-compose exec -i -t verusd.chips_$CLONE verus -chain=chips777 -testnet addnode 49.13.136.34 add
	#docker-compose exec -i -t verusd.chips_$CLONE verus -chain=chips777 -testnet addnode testnet.chips.cash add
	#docker-compose exec -i -t verusd.chips_$CLONE verus -chain=chips777 -testnet addnode 144.217.65.10 add
	#docker-compose exec -i -t verusd.chips_$CLONE verus -chain=chips777 -testnet addnode 198.244.188.47 add
	#docker-compose exec -i -t verusd.chips_$CLONE verus -chain=chips777 -testnet addnode 15.235.160.231 add
	#docker-compose exec -i -t verusd.chips_$CLONE verus -chain=chips777 -testnet addnode 167.114.197.252 add
	#docker-compose exec -i -t verusd.chips_$CLONE verus -chain=chips777 -testnet addnode 167.114.197.250 add
	########
	cd ..
done
