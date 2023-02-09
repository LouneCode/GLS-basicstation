#!/bin/bash

set -e
cd $(dirname $0)

REMOTE_TAG=${REMOTE_TAG:-"v2.0.6"}
ARCH=${ARCH:-amd64}
VARIANT=${VARIANT:-std}

# Clone 
if [[ ! -d basicstation ]]; then
    git clone https://github.com/lorabasics/basicstation basicstation
fi

# Chack out tag
cd basicstation
git checkout ${REMOTE_TAG}

# Apply patches
if [ -f ../${REMOTE_TAG}.patch ]; then
    echo "Applying ${REMOTE_TAG}.patch ..."
    git apply ../${REMOTE_TAG}.patch

    if [ -f ../GLS_${REMOTE_TAG}.1.patch ]; then
        echo "Applying fine timestamp GLS_${REMOTE_TAG}.1.patc ..."
        git apply ../GLS_${REMOTE_TAG}.1.patch  
    fi

    # Build fixes for the docker alpine image 
    if [[ ${ARCH} == *"alpine-linux-musl" ]]; then

        if [ -f ../GLS_${REMOTE_TAG}.1.alpine.patch ]; then
            echo "Applying GLS_${REMOTE_TAG}.1.alpine.patch ..."
            git apply ../GLS_${REMOTE_TAG}.1.alpine.patch
        fi

    fi    

fi

# Build
make platform=corecell variant=${VARIANT} arch=${ARCH}
