#!/bin/sh

SOURCEBUILDFILE=$1
BUILDDIRECTORY=$2
BUILDCOMMAND=$3
REPODIRECTORY=$4

function hashIt()
{
    type md5sum > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        HASH=$(md5sum ${SOURCEBUILDFILE} | cut -d' ' -f1)
        return 0
    fi
    type md5 > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        HASH=$(md5 ${SOURCEBUILDFILE} | rev | cut -d' ' -f1 | rev)
        return 0
    fi
    echo "md5 nor md5sum not found." >&2
    exit 3
}

if [ $# -ne 4 ];
then
    echo "Usage: $0 SOURCEBUILDFILE BUILDDIRECTORY BUILDCOMMAND REPODIRECTORY"
    exit 1
fi
if [ ! -d "${REPODIRECTORY}/" ]; then
    echo "Directory ${REPODIRECTORY} not found" >&2
fi
hashIt

if [ -e "${REPODIRECTORY}/${HASH}.gz" ]; then
    cd ${BUILDDIRECTORY}
    echo "Unpacking cached build."
    tar -xzf ${REPODIRECTORY}/${HASH}.gz -C .
else
    echo "No cached build found. Building"
    bash -c ${BUILDCOMMAND}
    if [ $? -ne 0 ]; then
        pwd
        echo "The build has failed." >&2
        exit 2
    fi
    if [ ! -d "${BUILDDIRECTORY}/" ]; then
        echo "Directory ${BUILDDIRECTORY} not found" >&2
    fi
    cd ${BUILDDIRECTORY}
    tar -czf ${REPODIRECTORY}/${HASH}.gz.$$ .
    mv ${REPODIRECTORY}/${HASH}.gz.$$ ${REPODIRECTORY}/${HASH}.gz
    echo "Stored cached build found in ${REPODIRECTORY}/${HASH}.gz"
fi
cd -