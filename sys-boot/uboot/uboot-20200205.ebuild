# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Uboot"
HOMEPAGE=""
EGIT_REPO_URI="https://git.eno.space/pbp-uboot.git"
EGIT_BRANCH="nvme"
EGIT_COMMIT="908d441fefc2203affe1bb0d79f75f611888fc1f"

LICENSE="GPL2"
SLOT="0"
KEYWORDS=""
IUSE="build-atf"

DEPEND="
	!build-atf? ( sys-firmware/arm-trusted-firmware-bin )
	build-atf? ( sys-firmware/arm-trusted-firmware )
"
RDEPEND="${DEPEND}"
BDEPEND=""


src_compile() {
	unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS

	emake pinebook_pro-rk3399_defconfig || die
	emake BL31=/usr/share/arm-trusted-firmware/build/rk3399/release/bl31/bl31.elf || die
}

src_install() {
	insinto /usr/share/uboot
	doins idbloader.img
	doins u-boot.itb
}
