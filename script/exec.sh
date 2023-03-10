#!/bin/bash

# ROOTDIR=$(cd "$(dirname "$0")" && pwd)

# export FABRIC_CFG_PATH=${PWD}/configtx
# export VERBOSE=false

# . script/utils.sh
# . script/registerEnroll.sh

# createOrderer 1

./script/cleanall.sh
sleep 1
./script/0_start_ca.sh
sleep 1
./script/1_register.sh
sleep 1
./script/2_enroll.sh
sleep 1
./script/3_start_net.sh
