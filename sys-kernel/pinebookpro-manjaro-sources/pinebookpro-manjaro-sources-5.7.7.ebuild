# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="8"

inherit kernel-2
detect_version
detect_arch

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
IUSE="experimental"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

src_prepare() {
	eapply "${FILESDIR}/0001-net-smsc95xx-Allow-mac-address-to-be-set-as-a-parame.patch"
	eapply "${FILESDIR}/0009-drivers-power-supply-Add-support-for-cw2015.patch"
	eapply "${FILESDIR}/0010-arm64-dts-rockchip-add-cw2015-node-to-PBP.patch"
	eapply "${FILESDIR}/0011-fix-wonky-wifi-bt-on-PBP.patch"
	eapply "${FILESDIR}/0012-add-suspend-to-rk3399-PBP.patch"
	eapply "${FILESDIR}/0013-arm64-dts-rockchip-setup-USB-type-c-port-as-dual-dat.patch"
	eapply "${FILESDIR}/0015-add-dp-alt-mode-to-PBP.patch"
	cp "${FILESDIR}/config-${PV}" "${S}/.config"
	cp "${FILESDIR}/config-${PV}" "${S}/manjaro_config"

	kernel-2_src_prepare
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
