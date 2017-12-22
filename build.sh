#!/bin/bash
patch -Np1 -i ${SHED_PATCHDIR}/openssh-7.5p1-openssl-1.1.0-1.patch
./configure --prefix=/usr                     \
            --sysconfdir=/etc/ssh             \
            --with-md5-passwords              \
            --with-privsep-path=/var/lib/sshd
make -j $SHED_NUMJOBS
make DESTDIR=${SHED_FAKEROOT} install
mkdir -pv ${SHED_FAKEROOT}/usr/bin
install -v -m755 contrib/ssh-copy-id ${SHED_FAKEROOT}/usr/bin
install -dm755 ${SHED_FAKEROOT}/lib/systemd/system
install -m644 ${SHED_CONTRIBDIR}/sshd.service ${SHED_FAKEROOT}/lib/systemd/system/
install -m644 ${SHED_CONTRIBDIR}/sshdat.service ${SHED_FAKEROOT}/lib/systemd/system/sshd@.service
install -m644 ${SHED_CONTRIBDIR}/sshd.socket ${SHED_FAKEROOT}/lib/systemd/system/
mkdir -pv ${SHED_FAKEROOT}/usr/share/man/man1
install -v -m644 contrib/ssh-copy-id.1 ${SHED_FAKEROOT}/usr/share/man/man1
install -v -m755 -d ${SHED_FAKEROOT}/usr/share/doc/openssh-7.5p1
install -v -m644 INSTALL LICENCE OVERVIEW README* ${SHED_FAKEROOT}/usr/share/doc/openssh-7.5p1
mv "${SHED_FAKEROOT}/etc/ssh/ssh_config" "${SHED_FAKEROOT}/etc/ssh/ssh_config.default"
mv "${SHED_FAKEROOT}/etc/ssh/sshd_config" "${SHED_FAKEROOT}/etc/ssh/sshd_config.default"
echo "PermitRootLogin yes" >> "${SHED_FAKEROOT}/etc/ssh/sshd_config.default"
