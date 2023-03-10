#!/bin/bash -eu

. script/utils.sh

infoln "registration doing ..."

infoln "Working on ca.origin.myproject.com"
export FABRIC_CA_CLIENT_TLS_CERTFILES=$LOCAL_CA_PATH/ca.origin.myproject.com/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=$LOCAL_CA_PATH/ca.origin.myproject.com/ca/admin
fabric-ca-client enroll -d -u https://ca-admin:ca-adminpw@ca.origin.myproject.com:7050
fabric-ca-client register -d --id.name admin --id.secret adminpw --id.type admin -u https://ca.origin.myproject.com:7050
fabric-ca-client register -d --id.name orderer1 --id.secret ordererpw --id.type orderer -u https://ca.origin.myproject.com:7050
fabric-ca-client register -d --id.name orderer2 --id.secret ordererpw --id.type orderer -u https://ca.origin.myproject.com:7050
fabric-ca-client register -d --id.name orderer3 --id.secret ordererpw --id.type orderer -u https://ca.origin.myproject.com:7050
fabric-ca-client register -d --id.name peer1 --id.secret peerpw --id.type peer -u https://ca.origin.myproject.com:7050

infoln "registration done"