#!/bin/sh
APP_NAME=argo-decoder
BASEDIR=/app

# JAVA_OPTS="-D${APP_NAME}.basedir=${BASEDIR}"
echo "*** Starting ${APP_NAME} batch ***"
/app/run.sh $@