# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ATF"
HOMEPAGE="https://developer.trustedfirmware.org/dashboard/view/6/"
SRC_URI="https://github.com/ARM-software/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="arm64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND} !sys-firmware/arm-trusted-firmware-bin"
BDEPEND=""

src_compile() {
	which arm-none-eabi-gcc || die "arm-none-eabi toolchain not found!"
	unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
	emake PLAT=rk3399 || die
}

src_install() {
	insinto /usr/share/${PN}
	doins -r build
}
