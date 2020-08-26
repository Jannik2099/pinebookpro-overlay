# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Extlinux script for the PinebookPro"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/Jannik2099/u-boot-menu.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Jannik2099/u-boot-menu/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm64"

S="${WORKDIR}/u-boot-menu-${PV}"

src_install() {
	dobin u-boot-update
	doman u-boot-update.8
	if ! test -f /etc/default/u-boot; then
		insinto /etc/default
		newins default u-boot
	fi
}
