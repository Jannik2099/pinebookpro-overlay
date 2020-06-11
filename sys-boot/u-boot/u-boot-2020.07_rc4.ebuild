# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PV=$(ver_rs 2 -)
MY_P="${PN}-v${MY_PV}"

DESCRIPTION="U-boot"
HOMEPAGE="https://www.denx.de/wiki/U-Boot"
SRC_URI="https://gitlab.denx.de/${PN}/${PN}/-/archive/v${MY_PV}/${PN}-v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~arm64"
IUSE="build-tfa"

DEPEND="
	sys-apps/dtc
	!build-tfa? ( sys-firmware/trusted-firmware-a-bin )
	build-tfa? ( sys-firmware/trusted-firmware-a )
"
RDEPEND="${DEPEND}"
BDEPEND=""
S="${WORKDIR}/${MY_P}"

src_configure() {
	emake pinebook-pro-rk3399_defconfig || die
}

src_compile() {
	emake BL31=/usr/share/trusted-firmware-a/rk3399/bl31.elf || die
}

src_install() {
	insinto /usr/share/u-boot
	doins idbloader.img || die
	doins u-boot.itb || die
}

pkg_postinst() {
	elog "To install U-boot:"
	elog "Determine your device, then"
	elog "if=/usr/share/u-boot/idbloader.img of=/dev/... seek=64 conv=notrunc"
	elog "if=/usr/share/u-boot/u-boot.itb of=/dev/... seek=16384 conv=notrunc"
}
