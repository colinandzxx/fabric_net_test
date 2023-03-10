#!/bin/bash -eu

. script/utils.sh

infoln "Preparation ============================="
mkdir -p $LOCAL_CA_PATH/ca.origin.myproject.com/assets
cp $LOCAL_CA_PATH/ca.origin.myproject.com/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/ca.origin.myproject.com/assets/ca-cert.pem
cp $LOCAL_CA_PATH/ca.origin.myproject.com/ca/crypto/ca-cert.pem $LOCAL_CA_PATH/ca.origin.myproject.com/assets/tls-ca-cert.pem
infoln "Preparation end =========================="

infoln "Start origin.myproject.com ============================="
infoln "Enroll admin"
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/ca.origin.myproject.com/registers/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://admin:adminpw@ca.origin.myproject.com:7050
# 加入通道时会用到admin/msp，其下必须要有admincers
mkdir -p $LOCAL_CA_PATH/ca.origin.myproject.com/registers/admin/msp/admincerts
cp $LOCAL_CA_PATH/ca.origin.myproject.com/registers/admin/msp/signcerts/cert.pem $LOCAL_CA_PATH/ca.origin.myproject.com/registers/admin/msp/admincerts/cert.pem

infoln "Enroll orderer1"
# for identity
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://orderer1:ordererpw@ca.origin.myproject.com:7050
mkdir -p $LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer1/msp/admincerts
cp $LOCAL_CA_PATH/ca.origin.myproject.com/registers/admin/msp/signcerts/cert.pem $LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer1/msp/admincerts/cert.pem
# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1:ordererpw@ca.origin.myproject.com:7050 --enrollment.profile tls --csr.hosts orderer1.origin.myproject.com
cp $LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer1/tls-msp/keystore/*_sk $LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer1/tls-msp/keystore/key.pem

infoln "Enroll orderer2"
# for identity
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://orderer2:ordererpw@ca.origin.myproject.com:7050
mkdir -p $LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer2/msp/admincerts
cp $LOCAL_CA_PATH/ca.origin.myproject.com/registers/admin/msp/signcerts/cert.pem $LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer2/msp/admincerts/cert.pem
# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer2:ordererpw@ca.origin.myproject.com:7050 --enrollment.profile tls --csr.hosts orderer2.origin.myproject.com
cp $LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer2/tls-msp/keystore/*_sk $LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer2/tls-msp/keystore/key.pem

infoln "Enroll orderer3"
# for identity
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer3
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://orderer3:ordererpw@ca.origin.myproject.com:7050
mkdir -p $LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer3/msp/admincerts
cp $LOCAL_CA_PATH/ca.origin.myproject.com/registers/admin/msp/signcerts/cert.pem $LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer3/msp/admincerts/cert.pem
# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer3:ordererpw@ca.origin.myproject.com:7050 --enrollment.profile tls --csr.hosts orderer3.origin.myproject.com
cp $LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer3/tls-msp/keystore/*_sk $LOCAL_CA_PATH/ca.origin.myproject.com/registers/orderer3/tls-msp/keystore/key.pem

infoln "Enroll peer1"
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/ca.origin.myproject.com/registers/peer1
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://peer1:peerpw@ca.origin.myproject.com:7050
# for TLS
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/ca.origin.myproject.com/assets/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer1:peerpw@ca.origin.myproject.com:7050 --enrollment.profile tls --csr.hosts peer1.origin.myproject.com
cp $LOCAL_CA_PATH/ca.origin.myproject.com/registers/peer1/tls-msp/keystore/*_sk $LOCAL_CA_PATH/ca.origin.myproject.com/registers/peer1/tls-msp/keystore/key.pem
mkdir -p $LOCAL_CA_PATH/ca.origin.myproject.com/registers/peer1/msp/admincerts
cp $LOCAL_CA_PATH/ca.origin.myproject.com/registers/admin/msp/signcerts/cert.pem $LOCAL_CA_PATH/ca.origin.myproject.com/registers/peer1/msp/admincerts/cert.pem

mkdir -p $LOCAL_CA_PATH/ca.origin.myproject.com/msp/admincerts
mkdir -p $LOCAL_CA_PATH/ca.origin.myproject.com/msp/cacerts
mkdir -p $LOCAL_CA_PATH/ca.origin.myproject.com/msp/tlscacerts
mkdir -p $LOCAL_CA_PATH/ca.origin.myproject.com/msp/users
cp $LOCAL_CA_PATH/ca.origin.myproject.com/assets/ca-cert.pem $LOCAL_CA_PATH/ca.origin.myproject.com/msp/cacerts/
cp $LOCAL_CA_PATH/ca.origin.myproject.com/assets/tls-ca-cert.pem $LOCAL_CA_PATH/ca.origin.myproject.com/msp/tlscacerts/
cp $LOCAL_CA_PATH/ca.origin.myproject.com/registers/admin/msp/signcerts/cert.pem $LOCAL_CA_PATH/ca.origin.myproject.com/msp/admincerts/cert.pem
cp $LOCAL_ROOT_PATH/config/config-msp.yaml $LOCAL_CA_PATH/ca.origin.myproject.com/msp/config.yaml
infoln "End origin.myproject.com ============================="