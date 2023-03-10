#!/bin/bash -eu

. script/utils.sh

export ORDERER_CA=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/tls-ca-cert.pem
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="originmyprojectcommsp"
export CORE_PEER_ADDRESS=peer1.origin.myproject.com:8050
export CORE_PEER_TLS_ROOTCERT_FILE=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/tls-ca-cert.pem
export CORE_PEER_MSPCONFIGPATH=$LOCAL_CA_PATH/ca.origin.myproject.com/registers/admin/msp

export CHAINCODE_ID=basic_1.0:a59a3240526cad6576ee46b17892fc5aa19e6ebad1fe6fb3d2d49ad6cb883fb8

# infoln "instantiate ${CHAINCODE_ID} .."
# peer chaincode instantiate -o orderer1.origin.myproject.com:9050 --tls --cafile $ORDERER_CA --channelID origin.myproject.channel --name basic --version 1.0 --peerAddresses peer1.origin.myproject.com:8050 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"function":"InitLedger","Args":[]}'
# sleep 5

# some problem, get nothing !!!
peer chaincode list --installed --tls --cafile $ORDERER_CA --channelID origin.myproject.channel --peerAddresses peer1.origin.myproject.com:8050 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
# some problem, get nothing !!!
peer chaincode list --instantiated --tls --cafile $ORDERER_CA --channelID origin.myproject.channel --peerAddresses peer1.origin.myproject.com:8050 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
# OK ~~
peer lifecycle chaincode queryinstalled --tls --cafile $ORDERER_CA --peerAddresses peer1.origin.myproject.com:8050 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE


infoln "init ${CHAINCODE_ID} ..."
peer chaincode invoke --isInit -o orderer1.origin.myproject.com:9050 --tls --cafile $ORDERER_CA --channelID origin.myproject.channel --name basic --peerAddresses peer1.origin.myproject.com:8050 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"function":"InitLedger","Args":[]}'

sleep 5

infoln "${CHAINCODE_ID} call func ..."
peer chaincode invoke -o orderer1.origin.myproject.com:9050 --tls --cafile $ORDERER_CA --channelID origin.myproject.channel --name basic --peerAddresses peer1.origin.myproject.com:8050 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE -c '{"Args":["GetAllAssets"]}'
