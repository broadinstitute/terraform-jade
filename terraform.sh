#!/bin/bash

DEFAULT_TERRAFORM_VERSION="0.12.6"
#DOCKER_IMAGE='broadinstitute/terraform:latest'
DOCKER_IMAGE="${DOCKER_IMAGE:-gcr.io/broad-dsp-gcr-public/terraform0.12:${TERRAFORM_VERSION:-${DEFAULT_TERRAFORM_VERSION}}}"
SUDO=

SCRIPT_DIR="$( cd -P "$( dirname "$BASH_SOURCE[0]" )" && pwd )"

usage() {
    PROG=`basename $0`
    echo "usage: ${PROG} [--version] [--help] <command> [<args>]"
}

if [ "$TERM" != "dumb" ] ; then
    TTY='-it'
fi

if [ `uname -s` != "Darwin" ]; then
    if [ ! -w "${DOCKER_SOCKET}" ];
    then
       SUDO='sudo'
    fi
fi

if [ -z "$1" ];
    then
    usage
    exit 1
fi

DATA_FQP="$( cd -P "${SCRIPT_DIR}" && pwd )"
if [ ! -d "${DATA_FQP}" ];
    then
    echo "Directory `${DATA_FQP}` does not exist...exiting."
    exit 2
fi

$SUDO docker run $TTY --rm -v ${HOME}/.vault-token:/root/.vault-token -v $DATA_FQP:/data $EXTRA_ENV $DOCKER_IMAGE $@
