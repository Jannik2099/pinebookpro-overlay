# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-build

MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 3 ))
MANJARO_COMMIT="a8079e21f74e876ba6d7b027f08d1e59c3643191"
GENTOO_CONFIG_VER=5.10.18

DESCRIPTION="Linux kernel built with Gentoo patches"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+=" https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	https://github.com/mgorny/gentoo-kernel-config/archive/v${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz

	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/config
		-> kernel-aarch64-manjaro.config-${PV}
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0007-pbp-support.patch
		-> 0007-pbp-support-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0011-nuumio-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch
		-> 0011-panfrost-gem-shrinker-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0014-typec-displayport-some-devices-have-pin-assignments-reversed.patch
		-> 0014-usbc-dp-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0015-usb-typec-tcpm-Add-generic-extcon-for-tcpm-enabled-devices.patch
		-> 0015-usbc-tcpm-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0016-usb-typec-tcpm-Add-generic-extcon-to-tcpm.patch
		-> 0016-usbc-tcpm-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0018-ayufan-drm-rockchip-add-support-for-modeline-32MHz-e.patch
		-> 0018-ayufan-drm-rockchip-add-support-for-modeline-32MHz-e-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0019-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay.patch
		-> 0019-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0020-arm64-dts-rockchip-setup-USB-type-c-port-as-dual-data-role.patch
		-> 0020-arm64-dts-rockchip-setup-USB-type-c-port-as-dual-data-role-${PV}.patch
	"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="-* ~arm64"
IUSE="debug"

RDEPEND="
	!sys-kernel/gentoo-kernel-bin:${SLOT}"
BDEPEND="
	debug? ( dev-util/dwarves )"
PDEPEND="
	>=virtual/dist-kernel-${PV}"

src_prepare() {
	PATCHES=(
		# meh, genpatches have no directory
		"${WORKDIR}"/*.patch
		"${DISTDIR}"/*-${PV}.patch
	)
	default

	cp "${DISTDIR}/kernel-aarch64-manjaro.config-${PV}" .config || die

	local merge_configs=(
		"${WORKDIR}/gentoo-kernel-config-${GENTOO_CONFIG_VER}"/base.config
	)
	use debug || merge_configs+=(
		"${WORKDIR}/gentoo-kernel-config-${GENTOO_CONFIG_VER}"/no-debug.config
	)
	kernel-build_merge_configs "${merge_configs[@]}"
}
