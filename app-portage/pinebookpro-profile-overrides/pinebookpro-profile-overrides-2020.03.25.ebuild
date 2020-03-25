# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="profile overrides for the Pinebook Pro"
HOMEPAGE="https://github.com/Jannik2099/pinebookpro-overlay/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	mkdir -p "${S}"
}

src_prepare() {
	cp -r "${FILESDIR}"/* "${S}"

	eapply_user
}

src_install() {
	insinto /etc/portage/profile
	doins -r "${S}"/*
}
