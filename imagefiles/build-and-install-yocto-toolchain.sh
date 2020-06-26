#!/usr/bin/env bash
#
# Fetch, unpack and install Yocto toolchain
#
# Usage:
#
#  build-and-install-yocto-toolchain.sh
#
# Options:
#
#
# Notes:
#
#  * build directory is /usr/src/
#
#  * install directory is /opt/yocto/{{ version }}/{{ toolchain_name }}/
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
YOCTO_DEST='/opt/yocto/current/toolchain/'

function _set_vars {
    case "$1" in

        x86_64-buildtools-nativesdk-standalone-2.6.4.sh)
            YOCTO_HASH='417634548a2e5448f775e1a5763025160d7a3f53188cb7797def0579a2965a4c'
            YOCTO_VERSION='2.6.4'
            YOCTO_FNAME="x86_64-buildtools-nativesdk-standalone-${YOCTO_VERSION}.sh"
            YOCTO_URL="https://downloads.yoctoproject.org/releases/yocto/yocto-${YOCTO_VERSION}/buildtools/${YOCTO_FNAME}"
            YOCTO_DEST="/opt/yocto/${YOCTO_VERSION}/buildtools/"
            ;;

        poky-glibc-x86_64-core-image-sato-aarch64-toolchain-ext-2.6.4.sh)
            YOCTO_HASH='55f754b535a7d3c999addf084bdd7cffb3670d9ca3e302d26cde96727cb5a92f'
            YOCTO_VERSION='2.6.4'
            YOCTO_FNAME="poky-glibc-x86_64-core-image-sato-aarch64-toolchain-ext-${YOCTO_VERSION}.sh"
            YOCTO_URL="https://downloads.yoctoproject.org/releases/yocto/yocto-${YOCTO_VERSION}/toolchain/x86_64/${YOCTO_FNAME}"
            YOCTO_DEST="/opt/yocto/${YOCTO_VERSION}/poky-glibc-x86_64-core-image-sato-aarch64-toolchain-ext-${YOCTO_VERSION}"
            ;;

        *)
            echo "Invalid hint ($1)"
            exit 1
            ;;
    esac
}

function _install_yocto_toolchain {
    #   -y         Automatic yes to all prompts
    #   -d <dir>   Install the SDK to <dir>
    # ======== Extensible SDK only options ============
    #   -n         Do not prepare the build system
    #   -p         Publish mode (implies -n)
    # ======== Advanced DEBUGGING ONLY OPTIONS ========
    #   -S         Save relocation scripts
    #   -R         Do not relocate executables
    #   -D         use set -x to see what is going on
    #   -l         list files that will be extracted
    mkdir -p "$(dirname "${YOCTO_DEST}")"
    ./"${YOCTO_FNAME}" -l
    ./"${YOCTO_FNAME}" -y -d "${YOCTO_DEST}"
}


function _post_install_cleanup {
    rm -f \
        ${YOCTO_DEST}/x86_64-buildtools-nativesdk-standalone-*.sh \
        ${YOCTO_DEST}/layers/build/bitbake/lib/*/*/__pycache__/*.pyc \
        ${YOCTO_DEST}/layers/build/bitbake/lib/*/__pycache__/*.pyc \
        ${YOCTO_DEST}/layers/build/meta/lib/*/*/__pycache__/*.pyc \
        ${YOCTO_DEST}/layers/build/meta/lib/*/__pycache__/*.pyc
}

function build_and_install_yocto_toolchain {
    local hint
    hint="${1?required}"

    _set_vars "${hint}"
    check_var "${YOCTO_FNAME}"
    check_var "${YOCTO_HASH}"
    check_var "${YOCTO_URL}"
    check_var "${YOCTO_DEST}"

    # Can't use curl here because we don't have it yet
    if [ -f "${YOCTO_FNAME}" ]; then
        sha256sum "${YOCTO_FNAME}"
        check_sha256sum "${YOCTO_FNAME}" "${YOCTO_HASH}"
    else
        wget -q "${YOCTO_URL}" -O "${YOCTO_FNAME}"
        sha256sum "${YOCTO_FNAME}"
        check_sha256sum "${YOCTO_FNAME}" "${YOCTO_HASH}"
    fi

    chmod +x "${YOCTO_FNAME}"
    ( _install_yocto_toolchain )
    rm "${YOCTO_FNAME}"

    _post_install_cleanup
}

# cd /usr/src
cd /tmp/
build_and_install_yocto_toolchain "$@"
