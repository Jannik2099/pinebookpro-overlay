# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-build

MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 1 ))
MANJARO_COMMIT="16cb321757e376838f927d82c401f96b17ac4144"

DESCRIPTION="Linux kernel built with Gentoo patches"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+=" https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz

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
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0017-dts-rockchip-remove-pcie-max-speed-from-pinebook-pro.patch
		-> 0017-rockchips-dts-pcie-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0013-nuumio-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch
		-> 0013-panfrost-gem-shrinker-${PV}.patch
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
		"${DISTDIR}"/*-${PV}.patch
		# meh, genpatches have no directory
		"${WORKDIR}"/*.patch
	)
	default

	cp "${DISTDIR}/kernel-aarch64-manjaro.config-${PV}" .config || die

	local config_tweaks=(
		# replace (none) with gentoo
		-e 's:^CONFIG_DEFAULT_HOSTNAME=:&"gentoo":'
		# we do support x32
		-e '/CONFIG_X86_X32/s:.*:CONFIG_X86_X32=y:'
		# disable signatures
		-e '/CONFIG_MODULE_SIG/d'
		-e '/CONFIG_SECURITY_LOCKDOWN/d'
		-e '/CONFIG_KEXEC_SIG/d'
		-e '/CONFIG_KEXEC_BZIMAGE_VERIFY_SIG/d'
		-e '/CONFIG_SYSTEM_EXTRA_CERTIFICATE/d'
		-e '/CONFIG_SIGNATURE/d'
		# remove massive array of LSMs
		-e 's/CONFIG_LSM=.*/CONFIG_LSM="yama"/'
		-e 's/CONFIG_DEFAULT_SECURITY_SELINUX=y/CONFIG_DEFAULT_SECURITY_DAC=y/'
		# nobody actually wants fips
		-e '/CONFIG_CRYPTO_FIPS/d'
		# these tests are really not necessary
		-e 's/.*CONFIG_CRYPTO_MANAGER_DISABLE_TESTS.*/CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y/'
		# probably not needed by anybody but developers
		-e '/CONFIG_CRYPTO_STATS/d'
		# 1000hz is excessive for laptops
		-e 's/CONFIG_HZ_1000=y/CONFIG_HZ_300=y/'
		# nobody is using this kernel on insane super computers
		-e 's/CONFIG_NR_CPUS=.*/CONFIG_NR_CPUS=512/'
		# we're not actually producing live patches for folks
		-e 's/CONFIG_LIVEPATCH=y/CONFIG_LIVEPATCH=n/'
		# this slows down networking in general
		-e 's/CONFIG_IP_FIB_TRIE_STATS=y/CONFIG_IP_FIB_TRIE_STATS=n/'
		# include font for normal and hidpi screens
		-e 's/.*CONFIG_FONTS.*/CONFIG_FONTS=y\nCONFIG_FONT_8x16=y\nCONFIG_FONT_TER16x32=y/'
		# we don't need to actually install system headers from this ebuild
		-e '/CONFIG_HEADERS_INSTALL/d'
		# enable /proc/config.gz, used by linux-info.eclass
		-e '/CONFIG_IKCONFIG/s:.*:CONFIG_IKCONFIG=y\nCONFIG_IKCONFIG_PROC=y:'
		# WireGuard was backported to 5.4 but we use old configs (#739128)
		-e '$aCONFIG_WIREGUARD=m'
	)
	use debug || config_tweaks+=(
		-e '/CONFIG_DEBUG_INFO/d'
		-e '/CONFIG_DEBUG_RODATA_TEST/d'
		-e '/CONFIG_DEBUG_VM/d'
		-e '/CONFIG_DEBUG_SHIRQ/d'
		-e '/CONFIG_DEBUG_LIST/d'
		-e '/CONFIG_BUG_ON_DATA_CORRUPTION/d'
		-e '/CONFIG_TORTURE_TEST/d'
		-e '/CONFIG_BOOTTIME_TRACING/d'
		-e '/CONFIG_RING_BUFFER_BENCHMARK/d'
		-e '/CONFIG_X86_DECODER_SELFTEST/d'
		-e '/CONFIG_KGDB/d'
	)
	[[ ${ARCH} == x86 ]] && config_tweaks+=(
		# fix autoenabling 64bit
		-e '2i\
# CONFIG_64BIT is not set'
	)
	sed -i "${config_tweaks[@]}" .config || die
}
