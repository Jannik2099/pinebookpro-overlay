# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

K_USEPV="yes"
ETYPE="sources"

inherit kernel-2

DESCRIPTION="Manjaro Kernel sources for the Pinebook Pro"
HOMEPAGE="https://gitlab.manjaro.org/tsys/linux-pinebook-pro"
SRC_URI="https://gitlab.manjaro.org/tsys/linux-pinebook-pro/-/archive/v5.5/linux-pinebook-pro-v5.5.tar.bz2"

KEYWORDS="~arm64"
IUSE="performance-patches recommended-patches"

S="${WORKDIR}/linux-pinebook-pro-v5.5"

src_unpack() {
	unpack ${A}
}

src_prepare() {
	if use performance-patches; then
		eapply ${FILESDIR}/performance-patches/*.patch
	fi

	if use recommended-patches; then
		eapply ${FILESDIR}/recommended-patches/*.patch
	fi

	eapply_user
}

src_configure() {
	if ! test -f ${S}/.config; then
		cp ${FILESDIR}/default-config ${S}/.config
	fi
}
