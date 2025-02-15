# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson-multilib

DESCRIPTION="WebP GDK Pixbuf Loader library"
HOMEPAGE="https://github.com/aruiz/webp-pixbuf-loader"
SRC_URI="https://github.com/aruiz/webp-pixbuf-loader/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/webp-pixbuf-loader-${PV}"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~loong ppc ppc64 ~riscv ~sparc x86"

RDEPEND="
	>x11-libs/gdk-pixbuf-2.22.0:2[${MULTILIB_USEDEP}]
	>=media-libs/libwebp-1.3.2:=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local emesonargs=(
		-Dupdate_cache=false
	)
	multilib_foreach_abi meson_src_configure
}

pkg_postinst() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER
	multilib_foreach_abi gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER
	multilib_foreach_abi gnome2_gdk_pixbuf_update
}
