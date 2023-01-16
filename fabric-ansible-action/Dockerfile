FROM ghcr.io/ibm-blockchain/ofs-ansibe:sha-1170b1f
#FROM fabric-ansible:latest
USER root
RUN curl -sSL https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -o /usr/local/bin/jq \
    && chmod +x /usr/local/bin/jq

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
