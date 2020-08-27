# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Trusted Firmware for A profile Arm CPUs - precompiled binaries"
HOMEPAGE="https://www.trustedfirmware.org/"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* arm64"

RDEPEND="!sys-firmware/trusted-firmware-a"

S="${WORKDIR}"

src_unpack() {
	cp "${FILESDIR}"/${PV}-bl31.elf bl31.elf || die
}

src_install() {
	insinto /usr/share/trusted-firmware-a/rk3399/
	doins bl31.elf
}
