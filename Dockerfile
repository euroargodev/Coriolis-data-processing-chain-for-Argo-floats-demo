FROM gitlab-registry.ifremer.fr/ifremer-commons/docker/images/ubuntu:22.04

ARG RUN_FILE=run_decode_argo_2_nc_rt.sh
ARG EXEC_FILE=decode_argo_2_nc_rt

COPY --chown=1000:1000 ${RUN_FILE} /app/run.sh
COPY --chown=1000:1000 ${EXEC_FILE} /app/exec
COPY --chown=1000:1000 entrypoint.sh .

RUN \
    chmod u+x entrypoint.sh

USER 1000:1000

ENTRYPOINT ["/entrypoint.sh"]
