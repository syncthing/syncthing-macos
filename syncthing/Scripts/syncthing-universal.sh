#!/bin/bash
set -euo pipefail

SYNCTHING_VERSION="1.12.1-rc.1"
SYNCTHING_DIST_URL="https://github.com/syncthing/syncthing/releases/download"

TMPDIR=`mktemp -d -t syncthing-macos-build`
#APP_RESOURCES_DIR="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Resources/syncthing"
APP_RESOURCES_DIR=${TMPDIR}/syncthing

function finish()
{
	rm -Rf ${TMPDIR}
}
trap finish EXIT

function download_and_unpack()
{
	CURL_ARGS="--connect-timeout 5 --max-time 10 --retry 5 --retry-delay 3 --retry-max-time 60"

	SYNCTHING_ARCH="$1"
	SYNCTHING_OUT="$2"
	SYNCTHING_FOLDER="syncthing-macos-${SYNCTHING_ARCH}-v${SYNCTHING_VERSION}"
	SYNCTHING_ZIPFILE_URL="${SYNCTHING_DIST_URL}/v${SYNCTHING_VERSION}/${SYNCTHING_FOLDER}.zip"
	SYNCTHING_ZIPFILE="${TMPDIR}/${SYNCTHING_FOLDER}.zip"

	curl ${CURL_ARGS} -s -L -o ${SYNCTHING_ZIPFILE} ${SYNCTHING_ZIPFILE_URL}
	tar -xvf "${SYNCTHING_ZIPFILE}" -C ${TMPDIR} --strip-components=1 ${SYNCTHING_FOLDER}/syncthing
	mv ${TMPDIR}/syncthing ${SYNCTHING_OUT}
}

if [ -f ${APP_RESOURCES_DIR}/syncthing ]; then
	echo "Syncthing already bundled"
	exit 0
fi

download_and_unpack "amd64" "${TMPDIR}/syncthing_amd64"
download_and_unpack "arm64" "${TMPDIR}/syncthing_arm64"

mkdir -p ${APP_RESOURCES_DIR}
lipo -create ${TMPDIR}/syncthing_amd64 ${TMPDIR}/syncthing_arm64 -output ${APP_RESOURCES_DIR}/syncthing

rm -R ${TMPDIR}
