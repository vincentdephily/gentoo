# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# multicall,split-usr must match between app-alternates and sys-apps
# kill,hostname,selinux may be set by sys-apps only, to install the prefixed tool without symlinking it
ALTERNATIVES=(
	"gnu:>=sys-apps/coreutils-9.9-r12[kill?,hostname?,selinux?,multicall=,split-usr=]"
	"uutils:>=sys-apps/uutils-coreutils-0.5.0-r1[selinux?]"
)

inherit app-alternatives

DESCRIPTION="coreutil symlinks"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="selinux kill hostname multicall split-usr"
REQUIRED_USE="uutils? ( !split-usr )"

# `hostname/kill` may come from other ebuilds depending on USE
# `groups` used to come from shadow, now deprecated
# Recent install-xattr fixes https://bugs.gentoo.org/963699
RDEPEND+="
	hostname? ( !sys-apps/net-tools[hostname] )
	kill? (
		!sys-apps/util-linux[kill]
		!sys-process/procps[kill]
	)
	!<sys-apps/shadow-4.19.0_rc1
	uutils? ( !<sys-apps/install-xattr-0.10-r2 )
"

# TODO: Handle shell completions with links and/or USE flags
# TODO: EROOT ?
src_install() {
	# Tools shared by all alternatives
	# Some alternatives may install tools that we won't link to
	local t_common="[ arch b2sum base32 base64 basename basenc
	   cat chgrp chmod chown chroot cksum comm cp csplit cut
	   date dd df dir dircolors dirname du echo env expand expr
	   factor false fmt fold head hostid id install join
	   link ln logname ls mkdir mkfifo mknod mktemp mv
	   nice nl nohup nproc numfmt od
	   paste pathchk pr printenv printf ptx pwd
	   readlink realpath rm rmdir
	   seq shred sha1sum sha224sum sha256sum sha384sum sha512sum shuf sleep sort split stat stdbuf stty sum sync
	   tac tail tee test timeout touch tr true truncate tsort tty
	   uname unexpand uniq unlink vdir
	   wc whoami yes
	   $(usev hostname) $(usev kill) $(usev selinux "chcon runcon")"

	# Gnu-specific tools
	# Excluding `groups`: Provided by shadow
	local t_gnu="pinky users who"

	# Uutils-specific tools
	# Excluding `groups,uptime,more`: Provided by shadow,net-tools,more
	# Excluding 'hashnum': Deprecated by upstream in favor of cksum
	local t_uutils="$(usev !elibc_musl "pinky users who")"

	case $(get_alternative) in
		gnu)
			for t in $t_common $t_gnu; do
				dosym $(usex multicall gcoreutils g$t) "/usr/bin/${t}"
				dosym "g${t}.1.bz2" "/usr/share/man/man1/${t}.1.bz2"
			done
			if use split-usr; then
				# Coreutils installs those to /bin
				for t in cat chgrp chmod chown cp date dd df echo\
						 false ln ls mkdir mknod mv pwd rm rmdir\
						 stty sync true $(usev hostname) $(usev kill); do
					mv "${D}/usr/bin/${t}" "${D}/bin/${t}"
				done
				# Coreutils installs those to /bin, plus a symlink in /usr/bin
				for t in basename chroot cut dir dirname du env\
						 expr head mkfifo mktemp readlink seq sleep\
						 sort tail touch tr tty uname vdir wc yes; do
					dosym "g${t}" "/bin/${t}"
				done
			fi
			;;
		uutils)
			for t in $t_common $t_uutils; do
				dosym "uu-coreutils" "/usr/bin/${t}"
				dosym "uu-${t}.1.bz2" "/usr/share/man/man1/${t}.1.bz2"
			done
			;;
	esac
}
