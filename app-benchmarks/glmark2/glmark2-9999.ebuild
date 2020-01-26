# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=(python2_7)
PYTHON_REQ_USE="threads(+)"

inherit python-any-r1
inherit waf-utils
inherit git-r3

DESCRIPTION=""
HOMEPAGE=""
EGIT_REPO_URI="https://github.com/glmark2/glmark2.git"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE="wayland gles2"

DEPEND="
media-libs/mesa[gles2=]
media-libs/libpng
"
RDEPEND="${DEPEND}"
BDEPEND=""
FLAVORS="drm-gl,x11-gl"

src_configure() {
	if use gles2; then
		FLAVORS+=",drm-glesv2,x11-glesv2"
		if use wayland; then
			FLAVORS+=",wayland-glesv2"
		fi
	fi

	if use wayland; then
		FLAVORS+=",wayland-gl"
	fi

	waf-utils_src_configure "--with-flavors=${FLAVORS}"
}

