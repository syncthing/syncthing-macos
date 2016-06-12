# Download and unpack syncthing into ${PRODUCT_NAME}.app/Contents/Resources
SYNCTHING_ARCH="amd64"
SYNCTHING_URL="https://api.github.com/repos/syncthing/syncthing/releases/latest"
APP_RESOURCES_DIR="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app/Contents/Resources"

DL_DIR="${BUILT_PRODUCTS_DIR}/dl"
TAR_DIR="${APP_RESOURCES_DIR}/syncthing"
SYNCTHING_TARBALL="${DL_DIR}/syncthing.tar.gz"
CURL_ARGS="--connect-timeout 5 --max-time 10 --retry 5 --retry-delay 3 --retry-max-time 60"

# Download syncthing tarball
if [ -f "${SYNCTHING_TARBALL}" ]; then
    echo "-- Syncthing already downloaded"
    echo "   > ${SYNCTHING_TARBALL}"
else
    echo "-- Downloading syncthing"

    SYNCTHING_TARBALL_URL=`curl ${CURL_ARGS} -s -L ${SYNCTHING_URL} | grep macosx-${SYNCTHING_ARCH} | grep browser_download_url | sed -e 's/.*"https\(.*\)"/https\1/'`

    echo "   From > ${SYNCTHING_TARBALL_URL}"
    echo "     To > ${SYNCTHING_TARBALL}"

    mkdir -p "${DL_DIR}"
    curl ${CURL_ARGS} -s -L -o ${SYNCTHING_TARBALL} ${SYNCTHING_TARBALL_URL}
fi

# Unpack to .app Resources folder
if [ -d "${TAR_DIR}" ]; then
    echo "-- Syncthing already unpacked"
    echo "   > ${TAR_DIR}"
else
    echo "-- Unpacking syncthing"
    echo "   > ${TAR_DIR}"
    mkdir -p "${TAR_DIR}"
    tar -xf "${SYNCTHING_TARBALL}" -C "${TAR_DIR}" --strip-components=1
fi