# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="4"
MANJARO_COMMIT="abdb802476d60e4b1d5a2d0b2584cac10621eab3"

inherit kernel-2
detect_version
detect_arch

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
IUSE="experimental"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/config
		-> kernel-aarch64-manjaro.config-${PV}
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0007-pbp-support.patch
		-> 0007-pbp-support-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0012-pwm-rockchip-Keep-enabled-PWMs-running-while-probing.patch
		-> 0012-rockchip-pwm-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0010-PCI-rockchip-Fix-PCIe-probing-in-5.9.patch
		-> 0010-rockchip-pcie-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0015-drm-panfrost-Coherency-support.patch
		-> 0015-panfrost-coherency-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0013-nuumio-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch
		-> 0013-panfrost-gem-shrinker-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0022-typec-displayport-some-devices-have-pin-assignments-reversed.patch
		-> 0022-usbc-dp-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0023-usb-typec-tcpm-Add-generic-extcon-for-tcpm-enabled-devices.patch
		-> 0023-usbc-tcpm-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0024-usb-typec-tcpm-Add-generic-extcon-to-tcpm.patch
		-> 0024-usbc-tcpm-${PV}.patch
"

src_prepare() {
	eapply "${DISTDIR}"/*-${PV}.patch
	cp "${DISTDIR}/kernel-aarch64-manjaro.config-${PV}" "${S}/.config" || die
	cp "${DISTDIR}/kernel-aarch64-manjaro.config-${PV}" "${S}/manjaro_config" || die

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
