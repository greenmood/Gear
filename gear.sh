#!/bin/bash
# Config
client_dir="$(which gear-node)"

main() {	
	local ip=`wget -qO- eth0.me`
	local host=`grep "hostname" /etc/telegraf/telegraf.conf | grep -oPm1 "(?<=\")([^%]+)(?=\")"`	
	local bodyHealth=`curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "system_health"}' http://localhost:9933/`
	local bodySyncState=`curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "system_syncState"}' http://localhost:9933/`
	local currentBlock=`jq .result.currentBlock <<< $bodySyncState`
	local highestBlock=`jq .result.highestBlock <<< $bodySyncState`
	local isSyncing=`jq .result.isSyncing <<< $bodyHealth`
	printf "substrate,host=$host currentBlock=$currentBlock,highestBlock=$highestBlock,isSyncing=$isSyncing\n"
}
main
