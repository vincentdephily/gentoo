# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	"gnu:>=sys-apps/coreutils-9.8-r2[kill?,hostname?,multicall?]"
	"uutils:>=sys-apps/uutils-coreutils-0.2.0-r1[selinux?]"
)

inherit app-alternatives

DESCRIPTION="coreutil symlinks"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="selinux kill hostname multicall"

# Tools shared by all alternatives and USE flags
TOOLS="[ arch base32 base64 basename basenc cat chgrp chmod chown chroot
	   cksum comm cp csplit cut date dd df dir dircolors dirname du echo
	   env expand expr factor false fmt fold head hostid id install join
	   link ln logname ls mkdir mkfifo mknod mktemp mv nice nl nohup
	   nproc numfmt od paste pathchk pinky pr printenv printf ptx pwd
	   readlink realpath rm rmdir seq shred shuf sleep sort split stat
	   stdbuf stty sum sync tac tail tee test timeout touch tr true
	   truncate tsort tty uname unexpand uniq unlink users vdir wc who
	   whoami yes"

# Gnu-specific tools
TOOLS_GNU="b2sum md5sum sha1sum sha224sum sha256sum sha384sum sha512sum"

# Uutils-specific tools
# Excluding `groups,uptime,more`: Provided by shadow,net-tools,more
TOOLS_UUTILS="hashsum"

# Tools behind USE flags:
# selinux (uutils): chcon runcon
# kill (gnu): kill
# hostname (gnu): hostname

src_install() {
	# TODO: Handle shell completions with links and/or USE flags
	# TODO: EROOT ?
	case $(get_alternative) in
		gnu)
			for t in $TOOLS $TOOLS_GNU $(usev selinux "chcon runcon") $(usev hostname) $(usev kill); do
				dosym $(usex multicall gcoreutils g$t) "/usr/bin/${t}"
				dosym "g${t}.1.bz2" "/usr/share/man/man1/${t}.1.bz2"
			done
			;;
		uutils)
			for t in $TOOLS $TOOLS_UUTILS $(usev selinux "chcon runcon") $(usev hostname) $(usev kill); do
				if [[ "$t" == install ]]; then
					# https://bugs.gentoo.org/963699
					# https://bugs.gentoo.org/961068#c28
					#newbin <(echo '#!/usr/bin/uu-coreutils install') install
					newbin /usr/bin/uu-coreutils install
				else
					dosym "uu-coreutils" "/usr/bin/${t}"
				fi
				dosym "uu-${t}.1.bz2" "/usr/share/man/man1/${t}.1.bz2"
			done
			;;
	esac
}
