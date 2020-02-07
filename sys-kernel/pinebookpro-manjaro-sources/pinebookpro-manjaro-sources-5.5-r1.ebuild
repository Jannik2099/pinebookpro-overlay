# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

K_USEPV="yes"
ETYPE="sources"

inherit kernel-2
commit="66d7a788eda490a15e64ddf3ebdff4b5f2f1b60f"

DESCRIPTION="Manjaro Kernel sources for the Pinebook Pro"
HOMEPAGE="https://gitlab.manjaro.org/tsys/linux-pinebook-pro"
SRC_URI="https://gitlab.manjaro.org/tsys/linux-pinebook-pro/-/archive/${commit}/linux-pinebook-pro-${commit}.tar.bz2"

KEYWORDS="~arm64"
IUSE="performance-patches recommended-patches"

S="${WORKDIR}/linux-pinebook-pro-${PVR}"

src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/linux-pinebook-pro-${commit} ${WORKDIR}/linux-pinebook-pro-${PVR} || die
}

src_prepare() {
	if use performance-patches; then
		eapply ${FILESDIR}/performance-patches/*.patch || die
	fi

	if use recommended-patches; then
		eapply ${FILESDIR}/recommended-patches/*.patch || die
	fi

	eapply_user
}

src_configure() {
	cp ${FILESDIR}/default-config ${S}/.config
}
