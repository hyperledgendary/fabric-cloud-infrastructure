FROM ghcr.io/ibm-blockchain/ofs-ansibe:sha-ac6fd82

RUN microdnf install jq 

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]