#!/bin/bash

PROG=$( basename $0 )
env_arg=""
env_env="${ENVIRONMENT}"
proj_env="jade"  # force the project to be jade
initials_env="${INITIALS}"

SCRIPT_DIR="$( cd -P "$( dirname "$BASH_SOURCE[0]" )" && pwd )"
if [ -f "${SCRIPT_DIR}/config.sh" ]
then
   source "${SCRIPT_DIR}/config.sh"
fi

usage() {
  echo
  echo "Usage: ${PROG} [-e ENVIRONMENT] [-s SUFFIX]"
  echo
}

# process getopts
while getopts :e:p:s:h FLAG; do
   case $FLAG in
    h) usage
       exit 0
      ;;
    e) env_arg="${OPTARG}"
      ;;
    p) proj_arg="${OPTARG}"
      ;;
    s) initials_arg="${OPTARG}"
      ;;
   esac
done

shift $((OPTIND-1))

# ENVIRONMENT and PROJECT_NAME are determined using the following precedence
#  (lowest) source it from config.sh
#  if ENVIRONMENT environment var exists set it to that
#  (highest) if passed in set it to that value

if [ -z "${env_env}" -o "x${env_env}" == "x" ]; then
    if [ ! -z "${env_arg}" ]; then
         ENVIRONMENT="${env_arg}"
    fi
else
    if [ ! -z "${env_arg}" ]; then
         ENVIRONMENT="${env_arg}"
    else
         ENVIRONMENT="${env_env}"
    fi
fi

if [ -z "${proj_env}" -o "x${proj_env}" == "x" ]; then
    if [ ! -z "${proj_arg}" ]; then
         PROJECT_NAME="${proj_arg}"
    fi
else
    if [ ! -z "${proj_arg}" ]; then
         PROJECT_NAME="${proj_arg}"
    else
         PROJECT_NAME="${proj_env}"
    fi
fi

if [ -z "${initials_env}" -o "x${initials_env}" == "x" ]; then
    if [ ! -z "${initials_arg}" ]; then
         INITIALS="${initials_arg}"
    fi
else
    if [ ! -z "${initials_arg}" ]; then
         INITIALS="${initials_arg}"
    else
         INITIALS="${initials_env}"
    fi
fi

SUFFIX=${INITIALS:-$ENVIRONMENT}

if [ -z "${VAULT_TOKEN}" -o "x${VAULT_TOKEN}" == "x" ]; then
    export VAULT_TOKEN=${2-`cat /root/.vault-token`}
fi

if [ -z "${ENVIRONMENT}" ]; then
    echo "FATAL ERROR: Environment not defined!"
    exit 1
fi

if [ -z "${INITIALS}" ]; then
    echo "INITIALS not defined!"
    read -p "Are you sure you want to continue? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
      [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
    fi
fi

if [ -z "${VAULT_TOKEN}" ]; then
    echo "FATAL ERROR: Vault token not provided!"
    exit 1
fi

if [ -z "${PROJECT_NAME}" -o "x${PROJECT_NAME}" == "x" ]; then
    echo "FATAL ERROR: Project not set"
    exit 1
fi

export PROJECT_NAME ENVIRONMENT INITIALS SUFFIX


echo "Rendering other ctmpls"
# process all other ctmpls that do not start with env_
find . -name "*.ctmpl" -print | while read file
do
    rootname="${file%.ctmpl}"
    echo "$file -> $rootname"
    /usr/local/bin/consul-template \
        -once \
        -config=/etc/consul-template/config/config.json \
        -log-level=err \
        -template=${file}:${rootname}
done
