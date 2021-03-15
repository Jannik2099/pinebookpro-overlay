# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="7"
MANJARO_COMMIT="b2c73226b1eeb88fc66fbc987ac32b65b4efce08"

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
