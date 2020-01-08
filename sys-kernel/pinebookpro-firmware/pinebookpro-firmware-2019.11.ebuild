# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Firmware files for the Pinebook Pro that are not included in linux-firmware"
HOMEPAGE="https://gitlab.manjaro.org/manjaro-arm/packages/community/ap6256-firmware"
SRC_URI="https://gitlab.manjaro.org/manjaro-arm/packages/community/ap6256-firmware/-/archive/master/ap6256-firmware-master.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="arm64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/ap6256-firmware-master"
src_prepare() {
	rm PKGBUILD
	mkdir brcm

	cp BCM4345C5.hcd brcm/BCM.hcd
	cp BCM4345C5.hcd brcm/BCM4345C5.hcd

	cp nvram_ap6256.txt brcmfmac43456-sdio.pine64,pinebook-pro.txt

	mv fw_bcm43456c5_ag.bin brcm/brcmfmac43456-sdio.bin

	mv brcmfmac43456-sdio.clm_blob brcm/brcmfmac43456-sdio.clm_blob

	eapply_user
}

src_install() {
	insinto /lib/firmware
	insopts -Dm644
	doins -r *
}
