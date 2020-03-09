# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

K_USEPV="yes"
ETYPE="sources"

inherit kernel-2 git-r3

DESCRIPTION="Manjaro Kernel sources for the Pinebook Pro"
HOMEPAGE="https://gitlab.manjaro.org/tsys/linux-pinebook-pro"
EGIT_REPO_URI="https://gitlab.manjaro.org/tsys/linux-pinebook-pro.git"
EGIT_REPO_BRANCH="v5.5"
EGIT_REPO_COMMIT="9564c96de3d1e7a19fbfed075333bf414fa1749f"
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
	cp "${FILESDIR}"/default-config "${S}"/.config
}
