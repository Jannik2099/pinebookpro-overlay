# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION=" Xorg DDX driver for ARM devices"
HOMEPAGE="https://github.com/ssvb/xf86-video-fbturbo"
EGIT_REPO_URI="https://github.com/ssvb/xf86-video-fbturbo.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
x11-base/xorg-server
"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/0001-Use-own-thunk-functions-instead-of-fbdevHW-Weak.patch"
	"${FILESDIR}/0002-GCC-8-fix.patch"
)

src_configure() {
	./autogen.sh
	./configure --prefix=/usr --libdir=/usr/lib64
}

src_install() {
	default
	mkdir -p "${D}/etc/X11/xorg.conf.d"
	cp xorg.conf "${D}/etc/X11/xorg.conf.d/99-fbturbo.conf"
}
