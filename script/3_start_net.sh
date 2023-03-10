#!/bin/bash -eu

. script/utils.sh

infoln "bootstrap net ..."

infoln "bootstrap node ..."
docker-compose -f $LOCAL_ROOT_PATH/docker/compose/docker-compose.yaml up -d peer1.origin.myproject.com
docker-compose -f $LOCAL_ROOT_PATH/docker/compose/docker-compose.yaml up -d orderer1.origin.myproject.com orderer2.origin.myproject.com orderer3.origin.myproject.com
sleep 5

infoln "genisis block ..."
configtxgen -profile OrgsChannel -outputCreateChannelTx $LOCAL_ROOT_PATH/data/origin.myproject.channel.tx -channelID origin.myproject.channel
configtxgen -profile OrgsChannel -outputBlock $LOCAL_ROOT_PATH/data/origin.myproject.channel.block -channelID origin.myproject.channel

infoln "set assets ..."
cp $LOCAL_ROOT_PATH/data/origin.myproject.channel.block $LOCAL_CA_PATH/ca.origin.myproject.com/assets/

infoln "set up orderer1 ..."
export ORDERER_CA=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/tls-ca-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=$LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer1/tls-msp/signcerts/cert.pem
export ORDERER_ADMIN_TLS_PRIVATE_KEY=$LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer1/tls-msp/keystore/key.pem
osnadmin channel join -o orderer1.origin.myproject.com:9051 --channelID origin.myproject.channel --config-block $LOCAL_ROOT_PATH/data/origin.myproject.channel.block --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
osnadmin channel list -o orderer1.origin.myproject.com:9051 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY

infoln "set up orderer2 ..."
export ORDERER_CA=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/tls-ca-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=$LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer2/tls-msp/signcerts/cert.pem
export ORDERER_ADMIN_TLS_PRIVATE_KEY=$LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer2/tls-msp/keystore/key.pem
osnadmin channel join -o orderer2.origin.myproject.com:9054 --channelID origin.myproject.channel --config-block $LOCAL_ROOT_PATH/data/origin.myproject.channel.block --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
osnadmin channel list -o orderer2.origin.myproject.com:9054 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY

infoln "set up orderer3 ..."
export ORDERER_CA=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/tls-ca-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=$LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer3/tls-msp/signcerts/cert.pem
export ORDERER_ADMIN_TLS_PRIVATE_KEY=$LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer3/tls-msp/keystore/key.pem
osnadmin channel join -o orderer3.origin.myproject.com:9057 --channelID origin.myproject.channel --config-block $LOCAL_ROOT_PATH/data/origin.myproject.channel.block --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
osnadmin channel list -o orderer3.origin.myproject.com:9057 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY

infoln "set up peer1 ..."
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="originmyprojectcommsp"
export CORE_PEER_ADDRESS=peer1.origin.myproject.com:8050
export CORE_PEER_TLS_ROOTCERT_FILE=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/tls-ca-cert.pem
export CORE_PEER_MSPCONFIGPATH=$LOCAL_CA_PATH/ca.origin.myproject.com/registers/admin/msp
peer channel join -b $LOCAL_CA_PATH/ca.origin.myproject.com/assets/origin.myproject.channel.block
peer channel list

infoln "bootstrap net done" 

# source envpeer1soft
# export ORDERER_ADMIN_TLS_SIGN_CERT=$LOCAL_CA_PATH/origin.myproject.com/registers/orderer1/tls-msp/signcerts/cert.pem
# export ORDERER_ADMIN_TLS_PRIVATE_KEY=$LOCAL_CA_PATH/origin.myproject.com/registers/orderer1/tls-msp/keystore/key.pem
# osnadmin channel join -o orderer1.origin.myproject.com:7052 --channelID testchannel --config-block $LOCAL_ROOT_PATH/data/testchannel.block --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
# osnadmin channel list -o orderer1.origin.myproject.com:7052 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY
# export ORDERER_ADMIN_TLS_SIGN_CERT=$LOCAL_CA_PATH/origin.myproject.com/registers/orderer2/tls-msp/signcerts/cert.pem
# export ORDERER_ADMIN_TLS_PRIVATE_KEY=$LOCAL_CA_PATH/origin.myproject.com/registers/orderer2/tls-msp/keystore/key.pem
# osnadmin channel join -o orderer2.origin.myproject.com:7055 --channelID testchannel --config-block $LOCAL_ROOT_PATH/data/testchannel.block --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
# osnadmin channel list -o orderer2.origin.myproject.com:7055 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY
# export ORDERER_ADMIN_TLS_SIGN_CERT=$LOCAL_CA_PATH/origin.myproject.com/registers/orderer3/tls-msp/signcerts/cert.pem
# export ORDERER_ADMIN_TLS_PRIVATE_KEY=$LOCAL_CA_PATH/origin.myproject.com/registers/orderer3/tls-msp/keystore/key.pem
# osnadmin channel join -o orderer3.origin.myproject.com:7058 --channelID testchannel --config-block $LOCAL_ROOT_PATH/data/testchannel.block --ca-file "$ORDERER_CA" --client-cert "$ORDERER_ADMIN_TLS_SIGN_CERT" --client-key "$ORDERER_ADMIN_TLS_PRIVATE_KEY"
# osnadmin channel list -o orderer3.origin.myproject.com:7058 --ca-file $ORDERER_CA --client-cert $ORDERER_ADMIN_TLS_SIGN_CERT --client-key $ORDERER_ADMIN_TLS_PRIVATE_KEY

# source envpeer1soft
# peer channel join -b $LOCAL_CA_PATH/soft.ifantasy.net/assets/testchannel.block
# peer channel list
# source envpeer1web
# peer channel join -b $LOCAL_CA_PATH/web.ifantasy.net/assets/testchannel.block
# peer channel list
# source envpeer1hard
# peer channel join -b $LOCAL_CA_PATH/hard.ifantasy.net/assets/testchannel.block
# peer channel list