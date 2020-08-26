# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Trusted Firmware for A profile Arm CPUs"
HOMEPAGE="https://www.trustedfirmware.org/"
SRC_URI="https://git.trustedfirmware.org/TF-A/${PN}.git/snapshot/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* arm64"
RDEPEND="!sys-firmware/trusted-firmware-a-bin"

src_compile() {
	which arm-none-eabi-gcc || die "arm-none-eabi toolchain not found!"
	unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
	emake PLAT=rk3399
}

src_install() {
	insinto /usr/share/${PN}/rk3399
	doins build/rk3399/release/bl31/bl31.elf
}
