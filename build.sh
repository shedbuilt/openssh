#!/bin/bash
declare -A SHED_PKG_LOCAL_OPTIONS=${SHED_PKG_OPTIONS_ASSOC}
SHED_PKG_LOCAL_DOCDIR="/usr/share/doc/${SHED_PKG_NAME}-${SHED_PKG_VERSION}"
# Patch for OpenSSL 1.1 support
patch -Np1 -i "${SHED_PKG_PATCH_DIR}/openssh-7.7p1-openssl-1.1.0-1.patch" &&
# Configure
./configure --prefix=/usr                     \
            --sysconfdir=/etc/ssh             \
            --with-md5-passwords              \
            --with-privsep-path=/var/lib/sshd &&
# Build and Install
make -j $SHED_NUM_JOBS &&
make DESTDIR="$SHED_FAKE_ROOT" install &&
# Rearrange
mkdir -pv "${SHED_FAKE_ROOT}/usr/bin" &&
install -v -m755 contrib/ssh-copy-id "${SHED_FAKE_ROOT}/usr/bin" &&
# Install systemd units
install -vdm755 "${SHED_FAKE_ROOT}/lib/systemd/system" &&
install -vm644 "${SHED_PKG_CONTRIB_DIR}/sshd.service" "${SHED_FAKE_ROOT}/lib/systemd/system/" &&
install -vm644 "${SHED_PKG_CONTRIB_DIR}/sshdat.service" "${SHED_FAKE_ROOT}/lib/systemd/system/sshd@.service" &&
install -vm644 "${SHED_PKG_CONTRIB_DIR}/sshd.socket" "${SHED_FAKE_ROOT}/lib/systemd/system/" &&
mkdir -pv "${SHED_FAKE_ROOT}/usr/share/man/man1" &&
install -v -m644 contrib/ssh-copy-id.1 "${SHED_FAKE_ROOT}/usr/share/man/man1" &&
# Install Default Config Files
echo "PermitRootLogin yes" >> "${SHED_FAKE_ROOT}/etc/ssh/sshd_config" &&
install -vdm755 "${SHED_FAKE_ROOT}/usr/share/defaults/etc/ssh" &&
mv "${SHED_FAKE_ROOT}/etc/ssh/ssh_config" "${SHED_FAKE_ROOT}/usr/share/defaults/etc/ssh" &&
mv "${SHED_FAKE_ROOT}/etc/ssh/sshd_config" "${SHED_FAKE_ROOT}/usr/share/defaults/etc/ssh" || exit 1
# Install Documentation
if [ -n "${SHED_PKG_LOCAL_OPTIONS[docs]}" ]; then
    install -v -dm755 "${SHED_FAKE_ROOT}${SHED_PKG_LOCAL_DOCDIR}" &&
    install -v -m644 INSTALL LICENCE OVERVIEW README* "${SHED_FAKE_ROOT}${SHED_PKG_LOCAL_DOCDIR}"
fi
