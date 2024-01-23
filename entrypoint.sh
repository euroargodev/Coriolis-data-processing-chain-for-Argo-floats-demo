#!/bin/sh
APP_NAME=argo-decoder
BASEDIR=/app

################################################################################
# CHECKS
################################################################################

# checks that the container is not running as root
USER_UID=$(id -u)
if [[ "${USER_UID}" -eq 0 ]]; then
    echo "[ERROR] The container cannot be run as root  (UID =0) !Did you forget to launch the container with '-u <user>' or '-u <uid>' option ?" >&2
    exit 3
fi

# checks that mounts exists
if [[ ! -d ${DATA_DIR} ]]; then
    echo "[ERROR] Data directory not found: '${DATA_DIR}'" >&2
    exit 3
fi
if [[ ! -d ${RUNTIME_DIR} ]]; then
    echo "[ERROR] Runtime directory not found: '${RUNTIME_DIR}'" >&2
    exit 3
fi
if [[ ! -d ${REF_DIR} ]]; then
    echo "[ERROR] References directory not found: '${REF_DIR}'" >&2
    exit 3
fi

#wget https://data-argo.ifremer.fr/ar_greylist.txt


# JAVA_OPTS="-D${APP_NAME}.basedir=${BASEDIR}"
echo "*** Starting ${APP_NAME} batch ***"
/app/run.sh $@