#!/bin/sh
set -x

SOURCEBUILDFILE=$1
BUILDDIRECTORY=$2
BUILDCOMMAND=$3
REPODIRECTORY=$4

if [ $# -ne 4 ];
then
    echo "$0 SOURCEBUILDFILE BUILDDIRECTORY BUILDCOMMAND REPODIRECTORY"
    exit 1
fi
HASH=$(md5 ${SOURCEBUILDFILE} | rev | cut -d' ' -f1 | rev)
if [ -e "${REPODIRECTORY}/${HASH}.gz" ]; then
    cd ${BUILDDIRECTORY}
    tar -xzf ${REPODIRECTORY}/${HASH}.gz -C ${BUILDDIRECTORY}
else
    bash -c ${BUILDCOMMAND}
    cd ${BUILDDIRECTORY}
    tar -czf ${REPODIRECTORY}/${HASH}.gz.$$ .
    mv ${REPODIRECTORY}/${HASH}.gz.$$ ${REPODIRECTORY}/${HASH}.gz
fi
