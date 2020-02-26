# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Extlinux script for the PinebookPro"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
EGIT_REPO_URI="https://github.com/Jannik2099/u-boot-menu.git"
EGIT_BRANCH="master"
EGIT_COMMIT="HEAD"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
dobin u-boot-update
doman u-boot-update.8
if [ ! test -f /etc/default/u-boot ]; then
	insinto /etc/default
	newins default u-boot
fi
}
