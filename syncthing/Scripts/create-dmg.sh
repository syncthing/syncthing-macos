#!/bin/bash
set -euo pipefail

if [ "${CONFIGURATION}" != "Release" ]; then
	echo "[SKIP] Not building an Release configuration, skipping DMG creation"
	exit
fi

SYNCTHING_DMG_VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${PROJECT_DIR}/syncthing/Info.plist")
SYNCTHING_DMG="${BUILT_PRODUCTS_DIR}/Syncthing-${SYNCTHING_DMG_VERSION}.dmg"
SYNCTHING_APP="${BUILT_PRODUCTS_DIR}/Syncthing.app"
SYNCTHING_APP_RESOURCES="${SYNCTHING_APP}/Contents/Resources"

CREATE_DMG="${SOURCE_ROOT}/3thparty/github.com/andreyvit/create-dmg/create-dmg"
STAGING_DIR="${BUILT_PRODUCTS_DIR}/staging/dmg"
STAGING_APP="${STAGING_DIR}/Syncthing.app"
DMG_TEMPLATE_DIR="${SOURCE_ROOT}/syncthing/Templates/DMG"
DEFAULT_IDENTITY=$(security find-identity -v -p codesigning | grep "Developer ID" | head -1 | cut -f 4 -d " " || true)

if [ -f "${SYNCTHING_DMG}" ]; then
	echo "-- Syncthing dmg already created"
	echo "   > ${SYNCTHING_DMG}"
else
	echo "-- Creating syncthing dmg"
	echo "   > ${SYNCTHING_DMG}"
	rm -rf ${STAGING_DIR}
	mkdir -p ${STAGING_DIR}
	cp -a -p ${SYNCTHING_APP} ${STAGING_DIR}

	if [[ ! -z "${SYNCTHING_APP_CODE_SIGN_IDENTITY+x}" ]]; then
		echo "-- Codesign with ${SYNCTHING_APP_CODE_SIGN_IDENTITY}"
		SELECTED_IDENTITY="${SYNCTHING_APP_CODE_SIGN_IDENTITY}"
	elif [[ ! -z "${DEFAULT_IDENTITY}" ]]; then
		echo "-- Using first valid identity (variable SYNCTHING_APP_CODE_SIGN_IDENTITY unset)"
		SELECTED_IDENTITY="${DEFAULT_IDENTITY}"
	else
		echo "-- Skip codesign (variable SYNCTHING_APP_CODE_SIGN_IDENTITY unset and no Developer ID identity found)"
		SELECTED_IDENTITY=""
	fi

	if [[ ! -z "${SELECTED_IDENTITY}" ]]; then
		codesign --force --deep --sign "${SELECTED_IDENTITY}" "${STAGING_APP}"
	fi

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

	if [[ ! -z "${SELECTED_IDENTITY}" ]]; then
		codesign --sign "${SELECTED_IDENTITY}" "${SYNCTHING_DMG}"
	fi
fi
