FROM gitlab-registry.ifremer.fr/ifremer-commons/docker/images/ubuntu:22.04

# confifurable arguments
ARG RUN_FILE=run_decode_argo_2_nc_rt.sh
ARG EXEC_FILE=decode_argo_2_nc_rt
ARG CONF=config
ARG GROUPID=9999
ARG DATA_DIR=/mnt/data
ARG RUNTIME_DIR=/mnt/runtime
ARG REF_DIR=/mnt/ref

# environment variables
ENV DATA_HOME=${DATA_DIR}
ENV RUNTIME_HOME=${RUNTIME_DIR}
ENV REF_HOME=${REF_DIR}
ENV MCR_CACHE_ROOT=/tmp/matlab/cache

# prepare os environment
RUN \
    apt-get -y update && \
    echo "===== MISE A JOUR OS =====" && \
    apt-get -y upgrade && \
    echo "===== ADD TOOLS LIBRARIES =====" && \
    apt-get -y install wget && \
    echo "===== ADD MATLAB REQUIRED LIBRARIES =====" && \
    apt-get -y install libxtst6 libxt6 && \
    echo "===== CREATION GROUPE UNIX gbatch (gid = ${GROUPID}) =====" && \
    groupadd --gid ${GROUPID} gbatch && \
    echo "===== GENERAL SYSTEM CLEANUP =====" && \
    apt-get purge -y manpages manpages-dev && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    apt-get clean -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/debconf/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/*

COPY ${RUN_FILE} /app/run.sh
COPY ${EXEC_FILE} /app/exec
COPY ${CONF} /app/config
COPY _argo_decoder_20240111_conf_ir_sbd.json /app/config/argo_conf_ir_sbd.json
COPY _argo_decoder_20240111_conf_ir_sbd_rem.json /app/config/argo_conf_ir_sbd_rem.json
COPY entrypoint.sh /app/entrypoint.sh

# adjust rights
RUN \
    # mkdir -p /tmp/matlab/cache && \
    chown -R root:gbatch /app /mnt /tmp && \
    chmod ug+x /app/entrypoint.sh /app/exec /app/run.sh

ENTRYPOINT ["/app/entrypoint.sh"]
