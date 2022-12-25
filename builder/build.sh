#!/bin/bash

set -e
cd $(dirname $0)

#REMOTE_TAG=${REMOTE_TAG:-"v2.0.6.1"}
VARIANT=${VARIANT:-std}

# Clone 
if [[ ! -d basicstation ]]; then
    git clone  https://github.com/LouneCode/gls-basicstation.git basicstation
fi

cd basicstation

# Build
make platform=corecell variant=${VARIANT}
