# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-build

MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 3 ))
MANJARO_COMMIT="b58a73f5d0523d18197ff3a67c40d7db607ec1e7"
GENTOO_CONFIG_VER=5.10.32

DESCRIPTION="Linux kernel built with Gentoo patches"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+=" https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	https://github.com/mgorny/gentoo-kernel-config/archive/v${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz

	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/config
		-> kernel-aarch64-manjaro.config-${PV}
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0009-nuumio-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch
		-> 0009-nuumio-panfrost-Silence-Panfrost-gem-shrinker-loggin-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0011-typec-displayport-some-devices-have-pin-assignments-reversed.patch
		-> 0011-typec-displayport-some-devices-have-pin-assignments-reversed-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0012-usb-typec-tcpm-Add-generic-extcon-for-tcpm-enabled-devices.patch
		-> 0012-usb-typec-tcpm-Add-generic-extcon-for-tcpm-enabled-devices-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0013-usb-typec-tcpm-Add-generic-extcon-to-tcpm.patch
		-> 0013-usb-typec-tcpm-Add-generic-extcon-to-tcpm-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0015-ayufan-drm-rockchip-add-support-for-modeline-32MHz-e.patch
		-> 0015-ayufan-drm-rockchip-add-support-for-modeline-32MHz-e-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0016-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay.patch
		-> 0016-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay-${PV}.patch

	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0017-tty-serdev-support-shutdown-op.patch
		-> 0017-tty-serdev-support-shutdown-op-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0018-bluetooth-hci_serdev-Clear-registered-bit-on-unregister.patch
		-> 0018-bluetooth-hci_serdev-Clear-registered-bit-on-unregister-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0019-bluetooth-hci_bcm-disable-power-on-shutdown.patch
		-> 0019-bluetooth-hci_bcm-disable-power-on-shutdown-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0020-mmc-core-pwrseq_simple-disable-mmc-power-on-shutdown.patch
		-> 0020-mmc-core-pwrseq_simple-disable-mmc-power-on-shutdown-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0021-usb-typec-bus-Catch-crash-due-to-partner-NULL-value.patch
		-> 0021-usb-typec-bus-Catch-crash-due-to-partner-NULL-value-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0022-phy-rockchip-typec-Set-extcon-capabilities.patch
		-> 0022-phy-rockchip-typec-Set-extcon-capabilities-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0023-usb-typec-altmodes-displayport-Add-hacky-generic-altmode.patch
		-> 0023-usb-typec-altmodes-displayport-Add-hacky-generic-altmode-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0024-sound-soc-codecs-es8316-Run-micdetect-only-if-jack-status.patch
		-> 0024-sound-soc-codecs-es8316-Run-micdetect-only-if-jack-status-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0025-ASoC-soc-jack.c-supported-inverted-jack-detect-GPIOs.patch
		-> 0025-ASoC-soc-jack.c-supported-inverted-jack-detect-GPIOs-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0026-arm64-dts-rockchip-add-typec-extcon-hack.patch
		-> 0026-arm64-dts-rockchip-add-typec-extcon-hack-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0027-arm64-dts-rockchip-setup-USB-type-c-port-as-dual-data-role.patch
		-> 0027-arm64-dts-rockchip-setup-USB-type-c-port-as-dual-data-role-${PV}.patch
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
