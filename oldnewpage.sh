#!/usr/bin/env bash
#Script to print html page for i2p pool
#from https://github.com/dominictarr/JSON.sh

#rewrite index.html
cp /home/gbone/moneroworld/base.html /home/gbone/moneroworld/index.html

dir="/home/gbone/moneroworld"
echo $dir
input=$(curl -X POST http://192.168.1.125:8119/stats)

#IFS=',' read -r -a darray <<< "$input"

#echo "${darray[0]}"
#poolfo=$(echo $input| ./json.sh | egrep '\["pool",[^"]*"\]')

#Mostly network info

pnetdiff=$(echo $input| $dir/json.sh | egrep '\["network","difficulty"\]')
netdiff=$(echo $pnetdiff | cut -f2 -d" ")
pnetheight=$(echo $input| $dir/json.sh | egrep '\["network","height"\]')
netheight=$(echo $pnetheight | cut -f2 -d" ")
pnethash=$(echo $input| $dir/json.sh | egrep '\["network","hash"\]')
nethash=$(echo $pnethash | cut -f2 -d" ")
ppoolfee=$(echo $input| $dir/json.sh | egrep '\["config","fee"\]')
poolfee=$(echo $ppoolfee | cut -f2 -d" ")
pdonations=$(echo $input| $dir/json.sh | egrep '\["config","donation"\]')
donations=$(echo $pdonations | cut -f2 -d" ")

#Network reward parsing
coinunits=$(echo $input| $dir/json.sh | egrep '\["config","coinUnits"\]')
rawnetreward=$(echo $input| $dir/json.sh | egrep '\["network","reward"\]')
netcln=$(echo $rawnetreward | cut -f2 -d" ")
coincln=$(echo $coinunits | cut -f2 -d" ")
netreward=$(echo $netcln/$coincln | bc -l)

#Pool info
ppoolblocks=$(echo $input| $dir/json.sh | egrep '\["pool","blocks"\]')
poolblocks=$(echo $ppoolblocks | cut -f2 -d" ")
ppooltotalblocks=$(echo $input| $dir/json.sh | egrep '\["pool","totalBlocks"\]')
pooltotalblocks=$(echo $ppooltotalblocks | cut -f2 -d" ")
ppoolpayments=$(echo $input| $dir/json.sh | egrep '\["pool","payments"\]')
poolpayments=$(echo $ppoolpayments | cut -f2 -d" ")
ppooltotpayments=$(echo $input| $dir/json.sh | egrep '\["pool","totalPayments"\]')
pooltotpayments=$(echo $ppooltotpayments | cut -f2 -d" ")
ppooltotminpaid=$(echo $input| $dir/json.sh | egrep '\["pool","totalMinersPaid"\]')
pooltotminpaid=$(echo $ppooltotminpaid | cut -f2 -d" ")
ppoolminers=$(echo $input| $dir/json.sh | egrep '\["pool","miners"\]')
poolminers=$(echo $ppoolminers | cut -f2 -d" ")
ppoolhr=$(echo $input| $dir/json.sh | egrep '\["pool","hashrate"\]')
poolhr=$(echo $ppoolhr | cut -f2 -d" ")

thedate=$(date)

echo -e  "<center><h2>--------- Start of Automatically Updated Information --------</h2></center> \n\
<h1>Stats Updated</h1>\n\
$thedate\n\
<h1>Network Information</h1> \n\
<h3>Network Difficulty</h3> \n\
$netdiff<br> \n\
<h3>Network Height</h3> \n\
$netheight<br> \n\
<h3>Hash of last block</h3> \n\
$nethash<br> \n\
<h3>Last Block Reward</h3> \n\
$netreward<br> \n\
<br>\n\
<h1>Pool Information</h1> \n\
this is where to look to see if your miner connected<br>\n\
<h3>Pool Total Number of Miners</h3> \n\
$poolminers<br> \n\
<h3>Pool Hashrate</h3> \n\
$poolhr hashes / second <br> \n\
<h3>Pool Blocks</h3> \n\
$poolblocks<br> \n\
<h3>Pool Total Blocks</h3> \n\
$pooltotalblocks<br> \n\
<h3>Pool Payments</h3> \n\
$poolpayments<br> \n\
<h3>Pool Total Payments</h3> \n\
$pooltotpayments<br> \n\
<h3>Pool Total Miners Paid</h3> \n\
$pooltotminpaid<br> \n\
" > /home/gbone/moneroworld/updatedinfo.html

cat /home/gbone/moneroworld/updatedinfo.html >> /home/gbone/moneroworld/index.html

sudo cp /home/gbone/moneroworld/index.html /var/www/i2ppool/public_html/
