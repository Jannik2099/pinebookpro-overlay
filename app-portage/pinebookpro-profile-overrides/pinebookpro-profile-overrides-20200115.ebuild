# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="profile overrides for the Pinebook Pro"
HOMEPAGE="https://github.com/Jannik2099/pinebookpro-overlay/"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="arm64"
IUSE="gles2 wayland"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	mkdir "${PF}"
}

DIR="etc/portage/repo.postsync.d"
src_prepare() {
	mkdir -p "${DIR}"
	cd "${DIR}"

	cp "${FILESDIR}"/0000-update-profile-overrides.sh .

	if use gles2; then
		find "${FILESDIR}"/* | grep gles2 | xargs -I {} cp {} .
	fi

	if use wayland; then
		find "${FILESDIR}"/* | grep wayland | xargs -I {} cp {} .
	fi

	eapply_user
}

src_install() {
	doins -r *
	find "${D}"/* | grep ".*\.sh" | xargs chmod 755
}

