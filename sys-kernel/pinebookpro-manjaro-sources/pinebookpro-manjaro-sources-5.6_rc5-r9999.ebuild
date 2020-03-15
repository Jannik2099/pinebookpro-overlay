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
EGIT_REPO_COMMIT="HEAD"
EGIT_CHECKOUT_DIR="linux-pinebook-pro-${PVR}"

KEYWORDS=""
IUSE="performance-patches recommended-patches"

S="${WORKDIR}"/linux-pinebook-pro-"${PVR}"

pkg_pretend() {
	ewarn 'This is a live ebuild, it follows git HEAD of the Tsys kernel repo'
	ewarn 'Regardless, I will always rename this to the newest rc so it triggers an update on your side'
	ewarn 'It is not possible to preserver previous rcs because Tsys rebases the branch, losing commit history'
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
