#!/bin/bash
set -euo pipefail

# Download and unpack syncthing into ${PRODUCT_NAME}.app/Contents/Resources
SYNCTHING_INOTIFY_ARCH="amd64"
SYNCTHING_INOTIFY_VERSION="0.8.7"
SYNCTHING_INOTIFY_DIST_URL="https://github.com/syncthing/syncthing-inotify/releases/download"
SYNCTHING_INOTIFY_TARBALL_URL="${SYNCTHING_INOTIFY_DIST_URL}/v${SYNCTHING_INOTIFY_VERSION}/syncthing-inotify-darwin-${SYNCTHING_INOTIFY_ARCH}-v${SYNCTHING_INOTIFY_VERSION}.tar.gz"

CURL_ARGS="--connect-timeout 5 --max-time 10 --retry 5 --retry-delay 3 --retry-max-time 60"
DL_DIR="${BUILT_PRODUCTS_DIR}/dl"
SYNCTHING_INOTIFY_TARBALL="${DL_DIR}/syncthing-inotify-${SYNCTHING_INOTIFY_VERSION}.tar.gz"
APP_RESOURCES_DIR="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Resources"
TAR_DIR="${APP_RESOURCES_DIR}/syncthing-inotify"

# Download syncthing tarball
if [ -f "${SYNCTHING_INOTIFY_TARBALL}" ]; then
    echo "-- Syncthing inotify already downloaded"
    echo "   > ${SYNCTHING_INOTIFY_TARBALL}"
else
    echo "-- Downloading syncthing"
    echo "   From > ${SYNCTHING_INOTIFY_TARBALL_URL}"
    echo "     To > ${SYNCTHING_INOTIFY_TARBALL}"

    mkdir -p "${DL_DIR}"
    curl ${CURL_ARGS} -s -L -o ${SYNCTHING_INOTIFY_TARBALL} ${SYNCTHING_INOTIFY_TARBALL_URL}
fi

# Unpack to .app Resources folder
if [ -d "${TAR_DIR}/syncthing-inotify" ]; then
    echo "-- Syncthing inotify already unpacked"
    echo "   > ${TAR_DIR}"
else
    echo "-- Unpacking syncthing"
    echo "   > ${TAR_DIR}"
    mkdir -p "${TAR_DIR}"
    tar -xf "${SYNCTHING_INOTIFY_TARBALL}" -C "${TAR_DIR}"
fi
