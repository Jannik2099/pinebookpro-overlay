# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-build

MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 2 ))
MANJARO_COMMIT="5134eb0a9e3887f7b72082e68ab5ac27174a31ee"
GENTOO_CONFIG_VER=5.13.4

DESCRIPTION="Linux kernel built with Gentoo patches"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+=" https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://dev.gentoo.org/~alicef/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~alicef/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	https://github.com/mgorny/gentoo-kernel-config/archive/v${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz
"
SRC_URI+="
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/config
		-> kernel-aarch64-manjaro.config-${PV}
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/archive/${MANJARO_COMMIT}/linux-${MANJARO_COMMIT}.tar.gz
		-> manjaro-patches-${PV}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="-* ~arm64"
IUSE="debug hardened"
REQUIRED_USE=""

RDEPEND="
	!sys-kernel/gentoo-kernel-bin:${SLOT}"
BDEPEND="
	debug? ( dev-util/pahole )"
PDEPEND="
	>=virtual/dist-kernel-${PV}"

QA_FLAGS_IGNORED="usr/src/linux-.*/scripts/gcc-plugins/.*.so"

src_prepare() {
	local PATCHES=(
		# meh, genpatches have no directory
		"${WORKDIR}"/*.patch
	)
	#Taken from the pkgbuild
	local MANJARO_PATCHES=(
		'0001-net-smsc95xx-Allow-mac-address-to-be-set-as-a-parame.patch'
		'0002-arm64-dts-rockchip-add-usb3-node-to-roc-cc-rock64.patch'
		'0003-arm64-dts-allwinner-add-hdmi-sound-to-pine-devices.patch'
		'0004-arm64-dts-allwinner-add-ohci-ehci-to-h5-nanopi.patch'
		'0005-drm-bridge-analogix_dp-Add-enable_psr-param.patch'
		'0006-gpu-drm-add-new-display-resolution-2560x1440.patch'
		'0007-nuumio-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch'
		'0008-arm64-dts-rockchip-Add-Firefly-Station-p1-support.patch'
		'0009-typec-displayport-some-devices-have-pin-assignments-reversed.patch'
		'0010-usb-typec-add-extcon-to-tcpm.patch'
		'0011-arm64-rockchip-add-DP-ALT-rockpro64.patch'
		'0012-ayufan-drm-rockchip-add-support-for-modeline-32MHz-e.patch'
		'0013-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay.patch'
		'0014-drm-meson-add-YUV422-output-support.patch'
		'0015-arm64-dts-meson-add-initial-Beelink-GT1-Ultimate-dev.patch'
		'0016-add-ugoos-device.patch'
		'0017-drm-meson-fix-green-pink-color-distortion-set-from-u.patch'
		'0018-drm-bridge-dw-hdmi-disable-loading-of-DW-HDMI-CEC-sub-driver.patch' #Applied for -next
		'0019-drm-panfrost-Handle-failure-in-panfrost_job_hw_submit.patch'
		'0001-phy-rockchip-typec-Set-extcon-capabilities.patch'
		'0002-usb-typec-altmodes-displayport-Add-hacky-generic-altmode.patch'
		'0003-arm64-dts-rockchip-add-typec-extcon-hack.patch'
		'0004-arm64-dts-rockchip-setup-USB-type-c-port-as-dual-data-role.patch'
		'0001-revert-arm64-dts-allwinner-a64-Add-I2S2-node.patch'
		'0002-Bluetooth-Add-new-quirk-for-broken-local-ext-features.patch'
		'0003-Bluetooth-btrtl-add-support-for-the-RTL8723CS.patch'
		'0004-arm64-allwinner-a64-enable-Bluetooth-On-Pinebook.patch'
		'0005-arm64-dts-allwinner-enable-bluetooth-pinetab-pinepho.patch'
		'0006-staging-add-rtl8723cs-driver.patch'
		'0007-pinetab-accelerometer.patch'
		'0008-enable-jack-detection-pinetab.patch'
		'0009-enable-hdmi-output-pinetab.patch'
		'0010-drm-panel-fix-PineTab-display.patch'
	)
	for patch in ${MANJARO_PATCHES}; do
		PATCHES+=("${WORKDIR}/linux-${MANJARO_COMMIT}/${patch}")
	done
	default

	cp "${DISTDIR}/kernel-aarch64-manjaro.config-${PV}" .config || die

	local myversion="-gentoo-dist"
	use hardened && myversion+="-hardened"
	echo "CONFIG_LOCALVERSION=\"${myversion}\"" > "${T}"/version.config || die
	local dist_conf_path="${WORKDIR}/gentoo-kernel-config-${GENTOO_CONFIG_VER}"

	local merge_configs=(
		"${T}"/version.config
		"${dist_conf_path}"/base.config
	)
	use debug || merge_configs+=(
		"${dist_conf_path}"/no-debug.config
	)
	if use hardened; then
		merge_configs+=( "${dist_conf_path}"/hardened-base.config )

		tc-is-gcc && merge_configs+=( "${dist_conf_path}"/hardened-gcc-plugins.config )

		if [[ -f "${dist_conf_path}/hardened-${ARCH}.config" ]]; then
			merge_configs+=( "${dist_conf_path}/hardened-${ARCH}.config" )
		fi
	fi
	kernel-build_merge_configs "${merge_configs[@]}"
}
