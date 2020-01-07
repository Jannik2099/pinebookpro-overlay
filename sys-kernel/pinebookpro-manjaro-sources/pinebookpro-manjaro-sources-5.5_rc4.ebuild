# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

K_NOUSENAME="yes"
K_NOSETEXTRAVERSION="yes"
ETYPE="sources"

inherit kernel-2

DESCRIPTION="Manjaro Kernel sources for the Pinebook Pro"
HOMEPAGE="https://gitlab.manjaro.org/tsys/linux-pinebook-pro"
SRC_URI="https://gitlab.manjaro.org/tsys/linux-pinebook-pro/-/archive/v5.5-rc4/linux-pinebook-pro-v5.5-rc4.tar.gz"

KEYWORDS="arm64"
IUSE="performance_patches recommended_patches"

S="${WORKDIR}/linux-pinebook-pro-v5.5-rc4"

src_unpack() {
	unpack ${A}
}

src_prepare() {
	if use performance_patches; then
		eapply ${FILESDIR}/performance_patches/*.patch
	fi

	if use recommended_patches; then
		if ! test -f ${S}/.config; then
			cp ${FILESDIR}/default-config ${S}/.config
		fi
		eapply ${FILESDIR}/recommended_patches/*.patch
	fi

	eapply_user
}
