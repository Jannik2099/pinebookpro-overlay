# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Extlinux script for the PinebookPro"
HOMEPAGE=""
SRC_URI="https://github.com/Jannik2099/u-boot-menu/archive/gentoo/v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="**"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/extlinux-${PV}"

src_unpack() {
unpack ${A}
mv ${WORKDIR}/u-boot-menu-gentoo-v${PV} ${WORKDIR}/extlinux-${PV} || die
}

src_prepare() {
if test -f /etc/default/u-boot; then
	cp /etc/default/u-boot default || die
fi

eapply_user
}

src_install() {
dobin u-boot-update
doman u-boot-update.8

insinto /etc/default
newins default u-boot
}
