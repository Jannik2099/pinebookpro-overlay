# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Miscellaneous files and fixes for full Pinebook Pro functionality"
HOMEPAGE="https://gitlab.manjaro.org/manjaro-arm/packages/community/pinebookpro-post-install"
EGIT_REPO_URI="https://gitlab.manjaro.org/manjaro-arm/packages/community/pinebookpro-post-install.git"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	rm PKGBUILD

	mkdir -p etc/udev/hwdb.d
	mv 10-usb-kbd.hwdb etc/udev/hwdb.d/10-usb-kbd.hwdb

	mkdir -p var/lib/alsa
	mv asound.state var/lib/alsa/asound.state

	eapply_user
}

src_install() {
	doins -r *
}

pkg_postinst() {
	if test -f /bin/systemctl; then
		systemd-hwdb update
	else
		udevadm hwdb --update
	fi
	udevadm control --reload
}
