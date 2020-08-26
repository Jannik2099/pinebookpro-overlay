# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Disables/enables the speaker on headphone plug/unplug"
HOMEPAGE="https://gitlab.manjaro.org/manjaro-arm/packages/community/pinebookpro-audio"
EGIT_REPO_URI="https://gitlab.manjaro.org/manjaro-arm/packages/community/pinebookpro-audio.git"
EGIT_COMMIT="fcb1538d5be5a6324a18a0684b254b52a9138a76"

inherit git-r3 linux-info

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"

RDEPEND="
	media-sound/alsa-utils
	sys-power/acpid
"

pkg_pretend() {
	if kernel_is -lt 5 6; then
		ewarn 'Warning: this feature only works as of 5.6_rc4!!!'
	fi
}

src_install() {
	insinto /etc/acpi/events
	doins audio_jack_plugged_in
	exeinto /etc/acpi
	doexe audio_jack_plugged_in.sh
}

pkg_postinst() {
	if test -f $(which systemctl); then
		systemctl try-restart acpid.service
		if ! systemctl is-active acpid.service; then
			ewarn 'acpid must be active for this to work.'
			ewarn 'try systemctl enable --now acpid.service'
		fi
	elif test -f $(which rc-service); then
		rc-service --ifstarted acpid restart
		if ! rc-service -N acpid status; then
			ewarn 'acpid must be active for this to work.'
			ewarn 'try rc-update add acpid default && rc-service acpid start'
		fi
	fi
}
