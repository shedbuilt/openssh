#!/bin/bash
patch -Np1 -i "${SHED_PKG_PATCH_DIR}/openssh-7.6p1-openssl-1.1.0-1.patch" && \
./configure --prefix=/usr                     \
            --sysconfdir=/etc/ssh             \
            --with-md5-passwords              \
            --with-privsep-path=/var/lib/sshd && \
make -j $SHED_NUM_JOBS && \
make DESTDIR="$SHED_FAKE_ROOT" install || exit 1
mkdir -pv "${SHED_FAKE_ROOT}/usr/bin"
install -v -m755 contrib/ssh-copy-id "${SHED_FAKE_ROOT}/usr/bin"
install -dm755 "${SHED_FAKE_ROOT}/lib/systemd/system"
install -m644 "${SHED_PKG_CONTRIB_DIR}/sshd.service" "${SHED_FAKE_ROOT}/lib/systemd/system/"
install -m644 "${SHED_PKG_CONTRIB_DIR}/sshdat.service" "${SHED_FAKE_ROOT}/lib/systemd/system/sshd@.service"
install -m644 "${SHED_PKG_CONTRIB_DIR}/sshd.socket" "${SHED_FAKE_ROOT}/lib/systemd/system/"
mkdir -pv "${SHED_FAKE_ROOT}/usr/share/man/man1"
install -v -m644 contrib/ssh-copy-id.1 "${SHED_FAKE_ROOT}/usr/share/man/man1"
install -v -dm755 "${SHED_FAKE_ROOT}/usr/share/doc/openssh-7.6p1"
install -v -m644 INSTALL LICENCE OVERVIEW README* "${SHED_FAKE_ROOT}/usr/share/doc/openssh-7.6p1"
mv "${SHED_FAKE_ROOT}/etc/ssh/ssh_config" "${SHED_FAKE_ROOT}/etc/ssh/ssh_config.default"
mv "${SHED_FAKE_ROOT}/etc/ssh/sshd_config" "${SHED_FAKE_ROOT}/etc/ssh/sshd_config.default"
echo "PermitRootLogin yes" >> "${SHED_FAKE_ROOT}/etc/ssh/sshd_config.default"
