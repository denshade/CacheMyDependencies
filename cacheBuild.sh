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
    tar -xzf ${REPODIRECTORY}/${HASH}.gz -C .
else
    bash -c ${BUILDCOMMAND}
    if [ $? -ne 0 ]; then
        echo "The build has failed." >2
        exit 2
    fi
    cd ${BUILDDIRECTORY}
    tar -czf ${REPODIRECTORY}/${HASH}.gz.$$ .
    mv ${REPODIRECTORY}/${HASH}.gz.$$ ${REPODIRECTORY}/${HASH}.gz
fi
cd -