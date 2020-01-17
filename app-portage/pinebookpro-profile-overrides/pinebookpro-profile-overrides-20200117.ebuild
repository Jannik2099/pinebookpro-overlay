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

DIR="etc/portage/profile"
src_prepare() {
	mkdir -p "${DIR}"
	cd "${DIR}"
	mkdir package.use.mask
	mkdir use.mask
	mkdir package.use.stable.mask

	if use gles2; then
		cp "${FILESDIR}"/gles2-global use.mask/gles2
		cp "${FILESDIR}"/gles2-package package.use.mask/gles2
	fi

	if use wayland; then
		cp "${FILESDIR}"/wayland-package-stable package.use.stable.mask/wayland
	fi

	mkdir ../repo.postsync.d
	cd ../repo.postsync.d
	cp "${FILESDIR}"/0000-update-profile-overrides.sh .

	eapply_user
}

src_install() {
	doins -r *
	chmod 755 "${D}"/etc/portage/repo.postsync.d/0000-update-profile-overrides.sh
}

