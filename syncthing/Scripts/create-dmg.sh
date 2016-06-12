#!/bin/bash
set -euo pipefail

SYNCTHING_DMG="${BUILT_PRODUCTS_DIR}/Syncthing.dmg"
SYNCTHING_APP="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app"
SYNCTHING_APP_RESOURCES="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Resources"

CREATE_DMG="${SOURCE_ROOT}/3thparty/github.com/andreyvit/create-dmg/create-dmg"
STAGING_DIR="${BUILT_PRODUCTS_DIR}/staging/dmg"
DMG_TEMPLATE_DIR="${SOURCE_ROOT}/syncthing/Templates/DMG"

if [ -f "${SYNCTHING_DMG}" ]; then
	echo "-- Syncthing dmg already created"
	echi "   > ${SYNCTHING_DMG}"
else
	echo "-- Creating syncthing dmg"
	echo "   > ${SYNCTHING_DMG}"
	mkdir -p ${STAGING_DIR}
	cp -r ${SYNCTHING_APP} ${STAGING_DIR}

	${CREATE_DMG} \
		--volname "Syncthing" \
		--volicon "${SYNCTHING_APP_RESOURCES}/syncthing.icns" \
		--background "${DMG_TEMPLATE_DIR}/background.png" \
		--window-pos -1 -1 \
		--window-size 480 540 \
		--icon "Syncthing.app" 240 130 \
		--hide-extension Syncthing.app \
		--app-drop-link 240 380 \
		${SYNCTHING_DMG} \
		${STAGING_DIR}
fi
