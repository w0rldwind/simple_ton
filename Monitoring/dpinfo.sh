#!/bin/bash
#Configs
msig=
depool=

dpinfo=$(./tonos-cli run $depool getParticipantInfo '{"addr":"'${msig}'"}' --abi DePool.abi.json)

stake1=$(echo "$dpinfo" | grep -oP '(?<="0x5": ")[^"]*')
stake1=$(printf '%x' ${stake1})
stake1=$((16#${stake1}))
stake1=$(bc -l <<< "scale=2; ${stake1}/1000000000")
echo Stake 1: $stake1

stake2=$(echo "$dpinfo" | grep -oP '(?<="0x6": ")[^"]*')
stake2=$(printf '%x' ${stake2})
stake2=$((16#${stake2}))
stake2=$(bc -l <<< "scale=2; ${stake2}/1000000000")
echo Stake 2: $stake2

reward=$(echo $dpinfo | grep -oP '(?<="reward": ")[^"]*')
reward=$(printf '%x' ${reward})
reward=$((16#${reward}))
reward=$(bc -l <<< "scale=2; ${reward}/1000000000")
echo Reward: $reward

total=$(echo "$dpinfo" | grep -oP '(?<="total": ")[^"]*')
total=$(printf '%x' ${total})
total=$((16#${total}))
total=$(bc -l <<< "scale=2; ${total}/1000000000")
echo Total: $total
