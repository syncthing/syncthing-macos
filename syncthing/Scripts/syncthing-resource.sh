#!/bin/bash
set -euo pipefail

# Download and unpack syncthing into ${PRODUCT_NAME}.app/Contents/Resources
SYNCTHING_ARCH="amd64"
SYNCTHING_VERSION="1.0.0"
SYNCTHING_DIST_URL="https://github.com/syncthing/syncthing/releases/download"
SYNCTHING_TARBALL_URL="${SYNCTHING_DIST_URL}/v${SYNCTHING_VERSION}/syncthing-macos-${SYNCTHING_ARCH}-v${SYNCTHING_VERSION}.tar.gz"

CURL_ARGS="--connect-timeout 5 --max-time 10 --retry 5 --retry-delay 3 --retry-max-time 60"
DL_DIR="${BUILT_PRODUCTS_DIR}/dl"
SYNCTHING_TARBALL="${DL_DIR}/syncthing-${SYNCTHING_VERSION}.tar.gz"
APP_RESOURCES_DIR="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Resources"
TAR_DIR="${APP_RESOURCES_DIR}/syncthing"

# Download syncthing tarball
if [ -f "${SYNCTHING_TARBALL}" ]; then
    echo "-- Syncthing already downloaded"
    echo "   > ${SYNCTHING_TARBALL}"
else
    echo "-- Downloading syncthing"
    echo "   From > ${SYNCTHING_TARBALL_URL}"
    echo "     To > ${SYNCTHING_TARBALL}"

    mkdir -p "${DL_DIR}"
    curl ${CURL_ARGS} -s -L -o ${SYNCTHING_TARBALL} ${SYNCTHING_TARBALL_URL}
fi

# Unpack to .app Resources folder
if [ -d "${TAR_DIR}/syncthing" ]; then
    echo "-- Syncthing already unpacked"
    echo "   > ${TAR_DIR}"
else
    echo "-- Unpacking syncthing"
    echo "   > ${TAR_DIR}"
    mkdir -p "${TAR_DIR}"
    tar -xf "${SYNCTHING_TARBALL}" -C "${TAR_DIR}" --strip-components=1
fi
