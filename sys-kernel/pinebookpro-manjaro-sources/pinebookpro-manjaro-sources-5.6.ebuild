# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

K_USEPV="yes"
ETYPE="sources"

inherit kernel-2 git-r3

DESCRIPTION="Manjaro Kernel sources for the Pinebook Pro"
HOMEPAGE="https://gitlab.manjaro.org/tsys/linux-pinebook-pro"
EGIT_REPO_URI="https://gitlab.manjaro.org/tsys/linux-pinebook-pro.git"
EGIT_REPO_BRANCH="v5.6"
EGIT_REPO_COMMIT="7614efe4b1fad784a96865e6e4a3b9d6feafb9f8"
EGIT_CHECKOUT_DIR="linux-pinebook-pro-${PVR}"

KEYWORDS="~arm64"
IUSE="performance-patches recommended-patches"

S="${WORKDIR}"/linux-pinebook-pro-"${PVR}"

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
	xzcat "${FILESDIR}/default-config.xz" > "${S}/.config"
}
