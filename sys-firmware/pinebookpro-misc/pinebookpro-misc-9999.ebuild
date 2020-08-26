# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Miscellaneous files and fixes for full Pinebook Pro functionality"
HOMEPAGE="https://gitlab.manjaro.org/manjaro-arm/packages/community/pinebookpro-post-install"
EGIT_REPO_URI="https://gitlab.manjaro.org/manjaro-arm/packages/community/pinebookpro-post-install.git"

LICENSE="GPL-3"
SLOT="0"

src_prepare() {
	rm PKGBUILD || die

	mkdir -p etc/udev/hwdb.d || die
	mv 10-usb-kbd.hwdb etc/udev/hwdb.d/10-usb-kbd.hwdb || die

	mkdir -p var/lib/alsa || die
	mv asound.state var/lib/alsa/asound.state || die

	default
}

src_install() {
	doins -r *
}

pkg_postinst() {
	if test -f /bin/systemctl; then
		systemd-hwdb update || die
	else
		udevadm hwdb --update || die
	fi
	udevadm control --reload || die
}
