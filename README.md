don't follow the dev instructions unless you know what you are doing, use the participate section

# dev
```
git clone https://github.com/imylomylo/prelaunch-chips-crosschain-500
cd prelaunch-chips-crosschain-500
START=$PWD
git submodule update --init --recursive

cd verusd
./build.sh
cd $START


screen -S vrsctest
./verusd.vrsctest.start
<ctrl> + <a>, <d>

...wait for vrsctest to sync
./verusd.vrsctest.stop

sudo ln -sf data_dir_vrsctest/vrsctest.conf vrsctest.conf
echo "rpcallowip=172.77.0.0/24" | sudo tee -a vrsctest.conf

screen -r vrsctest
./verusd.vrsctest.start
<ctrl> + <a>, <d>
```

# participate
```
not ready yet
```
