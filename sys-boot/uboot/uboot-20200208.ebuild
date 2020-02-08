# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Uboot"
HOMEPAGE=""
EGIT_REPO_URI="https://git.eno.space/pbp-uboot.git"
EGIT_BRANCH="master"
EGIT_COMMIT="365495a329c8e92ca4c134562d091df71b75845e"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm64"
IUSE="build-atf savedconfig"

DEPEND="
	sys-apps/dtc
	!build-atf? ( sys-firmware/arm-trusted-firmware-bin )
	build-atf? ( sys-firmware/arm-trusted-firmware )
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	if use savedconfig; then
		cp /etc/portage/sys-boot/uboot/uboot.config ${S}/.config || die "could not find uboot.config"
	else
		emake pinebook_pro-rk3399_defconfig || die
	fi
}

src_compile() {
	unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS
	emake BL31=/usr/share/arm-trusted-firmware/build/rk3399/release/bl31/bl31.elf || die
}

src_install() {
	insinto /usr/share/uboot
	doins idbloader.img || die
	doins u-boot.itb || die

	if ! use savedconfig; then
		cp .config uboot.config
		insinto /etc/portage/savedconfig/sys-boot/uboot
		doins uboot.config || die
	fi
}

pkg_postinst() {
	elog "To install U-boot:"
	elog "Determine your device, then"
	elog "if=/usr/share/uboot/idbloader.img of=/dev/... seek=64 conv=notrunc"
	elog "if=/usr/share/uboot/u-boot.itb of=/dev/... seek=16384 conv=notrunc"
}
