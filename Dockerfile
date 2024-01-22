FROM gitlab-registry.ifremer.fr/ifremer-commons/docker/images/ubuntu:22.04

# confifurable arguments
ARG RUN_FILE=run_decode_argo_2_nc_rt.sh
ARG EXEC_FILE=decode_argo_2_nc_rt
ARG JAVA_VERSION=11
ARG GROUPID=9999
ARG LIB_DIR=/data/lib
ARG WRK_DIR=/data/wrk
ARG EXE_DIR=/data/exe
ARG DCK_DIR=/data/exe

# environment variables
ENV LIB_HOME=${LIB_DIR}
ENV WRK_HOME=${WRK_DIR}
ENV EXE_HOME=${EXE_DIR}
ENV DCK_HOME=${DCK_DIR}

# prepare os environment
RUN \
    # apt-get -y update && \
    # echo "===== MISE A JOUR OS =====" && \
    # apt-get -y upgrade && \
    # echo "===== INSTALLATION JAVA - OPENJDK ${JAVA_VERSION}) =====" && \
    # apt-get -y install openjdk-${JAVA_VERSION}-jdk-headless && \
    # echo "Java version :" && \
    # java -version && \
    echo "===== CREATION GROUPE UNIX gbatch (gid = ${GROUPID}) =====" && \
    groupadd --gid ${GROUPID} gbatch && \
    echo "===== GENERAL SYSTEM CLEANUP =====" && \
    # apt-get purge -y manpages manpages-dev && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    apt-get clean -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/debconf/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/*

COPY ${RUN_FILE} /app/run.sh
COPY ${EXEC_FILE} /app/exec
COPY entrypoint.sh /app/entrypoint.sh
COPY _argo_decoder_20240111_conf_ir_sbd.json /tmp/_argo_decoder_20240111_conf_ir_sbd.json
COPY _argo_decoder_20240111_conf_ir_sbd_rem.json /tmp/_argo_decoder_20240111_conf_ir_sbd_rem.json

# adjust rights
RUN \
    mkdir -p ${LIB_DIR} ${WRK_DIR} ${EXE_DIR} ${DCK_DIR} && \
    chown -R root:gbatch /app && \
    chown -R root:gbatch /data && \
    chmod ug+x /app/entrypoint.sh /app/exec /app/run.sh

# use default user with no rights and required groupid
USER 207506:${GROUPID}

ENTRYPOINT ["/app/entrypoint.sh"]
