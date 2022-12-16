#!/bin/bash

images=(ghcr.io/hyperledger-labs/fabric-operator:4b222fe-amd64
    ghcr.io/ibm-blockchain/fabric-deployer:latest-amd64
    ghcr.io/hyperledger-labs/fabric-operator:4b222fe-amd64
    ghcr.io/ibm-blockchain/fabric-deployer:latest-amd64
    ghcr.io/hyperledger-labs/fabric-console:latest-amd64
    ghcr.io/hyperledger-labs/fabric-console:latest
    ghcr.io/hyperledger-labs/fabric-console:latest
    couchdb:3.2.1
    hyperledger/fabric-ca:1.5.5
    ghcr.io/hyperledger-labs/k8s-fabric-peer:v0.8.0
    hyperledger/fabric-orderer:2.4.3
    hyperledger/fabric-tools:2.4.3
    ghcr.io/hyperledger-labs/grpc-web:latest
)

for t in "${images[@]}"; do
    newtag=uk.icr.io/samara-alpha/"${t##*/}"
    
    docker pull "${t}"
    docker tag "${t}" "${newtag}"
    docker push "${newtag}"
    echo ------------------------------------------------------------
done

