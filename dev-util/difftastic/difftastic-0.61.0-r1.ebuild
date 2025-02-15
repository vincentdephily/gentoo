# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.13.3

EAPI=8

CRATES="
	ahash@0.8.11
	aho-corasick@1.1.3
	allocator-api2@0.2.16
	assert_cmd@2.0.8
	atty@0.2.14
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.5.0
	bstr@1.9.1
	bumpalo@3.14.0
	cc@1.1.30
	cfg-if@1.0.0
	clap@3.2.25
	clap_lex@0.2.4
	const_format@0.2.32
	const_format_proc_macros@0.2.32
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.19
	crossterm@0.27.0
	crossterm_winapi@0.9.1
	diff@0.1.13
	difflib@0.4.0
	doc-comment@0.3.3
	either@1.10.0
	env_logger@0.10.2
	equivalent@1.0.1
	errno@0.3.8
	fixedbitset@0.4.2
	float-cmp@0.9.0
	fnv@1.0.7
	glob@0.3.1
	globset@0.4.14
	hashbrown@0.12.3
	hashbrown@0.14.3
	heck@0.4.1
	hermit-abi@0.1.19
	hermit-abi@0.3.9
	home@0.5.5
	humansize@2.1.3
	humantime@2.1.0
	ignore@0.4.18
	indexmap@1.9.3
	indexmap@2.2.6
	io-lifetimes@1.0.11
	is-terminal@0.4.12
	itertools@0.10.5
	itertools@0.11.0
	itoa@1.0.10
	lazy_static@1.4.0
	libc@0.2.155
	libm@0.2.8
	libmimalloc-sys@0.1.24
	line-numbers@0.3.0
	linux-raw-sys@0.3.8
	lock_api@0.4.11
	log@0.4.21
	memchr@2.7.1
	mimalloc@0.1.28
	minimal-lexical@0.2.1
	mio@0.8.11
	nom@7.1.3
	normalize-line-endings@0.3.0
	num-traits@0.2.19
	once_cell@1.19.0
	os_str_bytes@6.6.1
	owo-colors@3.5.0
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	petgraph@0.6.4
	predicates-core@1.0.6
	predicates-tree@1.0.9
	predicates@2.1.1
	pretty_assertions@1.4.0
	pretty_env_logger@0.5.0
	proc-macro2@1.0.79
	quote@1.0.35
	radix-heap@0.4.2
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.4.1
	regex-automata@0.4.6
	regex-syntax@0.8.2
	regex@1.10.4
	rustc-hash@2.0.0
	rustix@0.37.27
	rustversion@1.0.14
	ryu@1.0.17
	same-file@1.0.6
	scopeguard@1.2.0
	serde@1.0.197
	serde_derive@1.0.197
	serde_json@1.0.114
	shlex@1.3.0
	signal-hook-mio@0.2.3
	signal-hook-registry@1.4.1
	signal-hook@0.3.17
	smallvec@1.13.2
	strsim@0.10.0
	strum@0.25.0
	strum_macros@0.25.3
	syn@2.0.55
	termcolor@1.4.1
	terminal_size@0.2.6
	termtree@0.4.1
	textwrap@0.16.1
	thread_local@1.1.8
	tree-sitter@0.20.10
	tree_magic_mini@3.1.5
	typed-arena@2.0.2
	unicode-ident@1.0.12
	unicode-width@0.1.11
	unicode-xid@0.2.4
	version_check@0.9.4
	wait-timeout@0.2.0
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.48.5
	windows-targets@0.52.4
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.4
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.4
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.4
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.4
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.4
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.4
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.4
	wu-diff@0.1.2
	yansi@0.5.1
	zerocopy-derive@0.7.32
	zerocopy@0.7.32
"

inherit cargo flag-o-matic

DESCRIPTION="A structural diff that understands syntax."
HOMEPAGE="http://difftastic.wilfred.me.uk/"
SRC_URI="
	https://github.com/Wilfred/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-DFS-2016 ZLIB"
# owo-colors
LICENSE+=" MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm64"

QA_FLAGS_IGNORED="usr/bin/difft"

DOCS=(
	CHANGELOG.md
	README.md
	manual/
)

src_prepare() {
	rm manual/.gitignore || die

	default
}

src_configure() {
	# Workaround for old bundled mimalloc in mimalloc crate, see
	# bug #944110, but updating it should be done with caution, see
	# https://github.com/purpleprotocol/mimalloc_rust/issues/109.
	append-cflags -std=gnu17
	cargo_src_configure
}

src_install() {
	cargo_src_install
	dodoc -r "${DOCS[@]}"
}
