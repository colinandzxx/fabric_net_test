#!/bin/bash -eu

. script/utils.sh

export ORDERER_CA=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/tls-ca-cert.pem
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="originmyprojectcommsp"
export CORE_PEER_ADDRESS=peer1.origin.myproject.com:8050
export CORE_PEER_TLS_ROOTCERT_FILE=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/tls-ca-cert.pem
export CORE_PEER_MSPCONFIGPATH=$LOCAL_CA_PATH/ca.origin.myproject.com/registers/admin/msp

export CHAINCODE_ID=basic_1.0:a59a3240526cad6576ee46b17892fc5aa19e6ebad1fe6fb3d2d49ad6cb883fb8

infoln "approve ${CHAINCODE_ID} ..."
peer lifecycle chaincode approveformyorg -o orderer1.origin.myproject.com:9050 --tls --cafile $ORDERER_CA  --channelID origin.myproject.channel --name basic --version 1.0 --sequence 1 --waitForEvent --init-required --package-id $CHAINCODE_ID
sleep 1
peer lifecycle chaincode queryapproved -o orderer2.origin.myproject.com:9053 -C origin.myproject.channel -n basic --sequence 1 

peer lifecycle chaincode checkcommitreadiness -o orderer2.origin.myproject.com:9053 --tls --cafile $ORDERER_CA --channelID origin.myproject.channel --name basic --version 1.0 --sequence 1 --init-required

infoln "commit ..."
peer lifecycle chaincode commit -o orderer1.origin.myproject.com:9050 --tls --cafile $ORDERER_CA --channelID origin.myproject.channel --name basic --init-required --version 1.0 --sequence 1 --peerAddresses peer1.origin.myproject.com:8050 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
sleep 1
peer lifecycle chaincode querycommitted --channelID origin.myproject.channel --name basic -o orderer2.origin.myproject.com:9053 --tls --cafile $ORDERER_CA --peerAddresses peer1.origin.myproject.com:8050 --tlsRootCertFiles $CORE_PEER_TLS_ROOTCERT_FILE
