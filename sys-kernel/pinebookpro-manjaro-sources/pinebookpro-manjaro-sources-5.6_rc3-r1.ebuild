# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

K_USEPV="yes"
ETYPE="sources"

inherit kernel-2
commit="602d84c5b3b16e4e3a5bb1d323e52e1ee9e10989"

DESCRIPTION="Manjaro Kernel sources for the Pinebook Pro"
HOMEPAGE="https://gitlab.manjaro.org/tsys/linux-pinebook-pro"
SRC_URI="https://gitlab.manjaro.org/tsys/linux-pinebook-pro/-/archive/${commit}/linux-pinebook-pro-${commit}.tar.bz2 -> ${PF}.tar.bz2"

KEYWORDS=""
IUSE="performance-patches recommended-patches"

S="${WORKDIR}"/linux-pinebook-pro-"${PVR}"

src_unpack() {
	unpack "${PF}".tar.bz2
	mv "${WORKDIR}"/linux-pinebook-pro-"${commit}" "${S}"
}

src_prepare() {
	if use performance-patches; then
		eapply "${FILESDIR}"/performance-patches/*.patch || die
	fi

	if use recommended-patches; then
		eapply "${FILESDIR}"/recommended-patches/*.patch || die
	fi

	eapply_user
}

src_configure() {
	cp "${FILESDIR}"/default-config "${S}"/.config
}
