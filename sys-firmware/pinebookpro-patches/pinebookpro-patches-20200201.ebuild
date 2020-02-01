# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Patches to be installed in /etc/portage/patches"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="arm64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""


src_unpack() {
	mkdir "${PF}"
}

src_prepare() {
	mkdir -p etc/portage/patches
	cp -r "${FILESDIR}"/* etc/portage/patches

	eapply_user
}

src_install() {
	doins -r *
}
