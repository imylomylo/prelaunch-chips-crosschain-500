#!/bin/bash
for i in `ls -d instance-1*`
do 
	cd $i
	########
	# docker-compose stop
	#cp ../helpers/c1eeedeffdb8be0150af4873155b2b88a9146e0d.conf .
	#mv -f c1eeedeffdb8be0150af4873155b2b88a9146e0d.conf data_dir/
	#docker-compose up -d
	########
	cd ..
done
