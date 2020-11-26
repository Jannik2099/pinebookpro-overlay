# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-build

MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-${PV##*.}
MANJARO_COMMIT="a340baadcf01fc3575b5d78a164296a287f38be1"
GENTOO_CONFIG_VER=5.9.8-r1

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
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0026-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay.patch
		-> 0026-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay-${PV}.patch
	"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="-* ~arm64"
IUSE="debug"

RDEPEND="
	!sys-kernel/vanilla-kernel:${SLOT}
	!sys-kernel/vanilla-kernel-bin:${SLOT}"
BDEPEND="
	debug? ( dev-util/dwarves )"

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
