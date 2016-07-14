#!/usr/bin/env sh

set -exu

REPO_ROOT=$(git rev-parse --show-toplevel)
DOCKERFILE=Dockerfile
NAME=datakit

docker build -t ${NAME} -f ${DOCKERFILE} ${REPO_ROOT}

docker rm -f ${NAME} || echo skip
docker run --name=${NAME} --rm  ${NAME}
