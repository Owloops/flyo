#!/bin/sh

set -e

sysctl vm.overcommit_memory=1 || true
sysctl net.core.somaxconn=1024 || true

PW_ARG=""
if [[ ! -z "${VALKEY_PASSWORD}" ]]; then
  PW_ARG="--requirepass $VALKEY_PASSWORD"
fi

: ${MAXMEMORY_POLICY:="volatile-lru"}
: ${APPENDONLY:="no"}
: ${FLY_VM_MEMORY_MB:=512}
if [ "${NOSAVE}" = "" ] ; then
  : ${SAVE:="3600 1 300 100 60 10000"}
fi
MAXMEMORY=$(($FLY_VM_MEMORY_MB*90/100))

valkey-server $PW_ARG \
  --dir /data/ \
  --maxmemory "${MAXMEMORY}mb" \
  --maxmemory-policy $MAXMEMORY_POLICY \
  --appendonly $APPENDONLY \
  --save "$SAVE"
