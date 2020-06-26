#!/usr/bin/env bash
#
# Fetch, unpack and install x86_64-buildtools-nativesdk-standalone
#
# Usage:
#
#  build-and-install-yocto-buildtools-nativesdk.sh
#
# Options:
#
#
# Notes:
#
#  * build directory is /usr/src/
#
#  * install directory is /opt/yocto-buildtools/
#
#  * after installation, build directory and archive are removed
#

set -ex
set -o pipefail

MY_DIR=$(dirname "${BASH_SOURCE[0]}")
source $MY_DIR/utils.sh

YOCTO_FNAME='x86_64-buildtools-nativesdk-standalone-2.6.4.sh'
YOCTO_HASH='417634548a2e5448f775e1a5763025160d7a3f53188cb7797def0579a2965a4c'
YOCTO_URL='https://downloads.yoctoproject.org/releases/yocto/yocto-2.6.4/buildtools/x86_64-buildtools-nativesdk-standalone-2.6.4.sh'

YOCTO_DEST='/opt/yocto-buildtools/'

function build_yocto_buildtools_native {
    local dest="$1"
    check_var "${YOCTO_FNAME}"
    check_var "${YOCTO_HASH}"
    check_var "${YOCTO_URL}"
    # Can't use curl here because we don't have it yet
    wget -q "${YOCTO_URL}" -O "${YOCTO_FNAME}"
    check_sha256sum "${YOCTO_FNAME}" "${YOCTO_HASH}"
    chmod +x ${YOCTO_FNAME}
    ( ./"${YOCTO_FNAME}" -y -d "${dest}" )
    rm ${YOCTO_FNAME}
}

cd /usr/src
build_yocto_buildtools_native "$YOCTO_DEST"
