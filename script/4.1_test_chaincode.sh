#!/bin/bash -eu

. script/utils.sh

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="originmyprojectcommsp"
export CORE_PEER_ADDRESS=peer1.origin.myproject.com:8050
export CORE_PEER_TLS_ROOTCERT_FILE=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/tls-ca-cert.pem
export CORE_PEER_MSPCONFIGPATH=$LOCAL_CA_PATH/ca.origin.myproject.com/registers/admin/msp

infoln "package basic.tar.gz for test ..."
peer lifecycle chaincode package basic.tar.gz --path ${LOCAL_ROOT_PATH}/asset-transfer-basic/chaincode-go/ --lang golang --label basic_1.0

infoln "install package ..."
peer lifecycle chaincode install basic.tar.gz
peer lifecycle chaincode queryinstalled