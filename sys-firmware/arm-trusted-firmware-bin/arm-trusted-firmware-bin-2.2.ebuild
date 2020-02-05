# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="arm64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND} !sys-firmware/arm-trusted-firmware"
BDEPEND=""

S=${WORKDIR}

src_unpack() {
	cp ${FILESDIR}/bl31.elf ${WORKDIR}/bl31.elf
}

src_install() {
	insinto /usr/share/arm-trusted-firmware/build/rk3399/release/bl31/
	doins bl31.elf
}
