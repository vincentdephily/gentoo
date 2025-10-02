#!/usr/bin/bash

# Parse options
echo "This script (re)creates coreutils symlinks that might be missing after migrating to a prefixed coreutils install."
echo "You will get a chance to inspect the commands before running them."
echo "The symlinks created here are not owned by portage, you should follow this up by installing"
echo "app-alternatives/coreutils or an older sys-apps/coreutils, and ignore the unowned file warning."
echo
OVERWRITE=true
PREFIX=g
while [[ -n "$1" ]]; do
    case "$1" in
        -n)
            OVERWRITE=false
            ;;
        -u)
            PREFIX=uu-
            ;;
        *)
            echo "Usage: $0 [-n] [-u]"
            echo " -n: Leave existing symlinks to non-gnu utils alone"
            echo " -u: Link to uutils-coreutils instead of gnu-coreutils"
            exit
    esac
    shift
done

# Sanity check
if [[ ! -f /usr/bin/${PREFIX}env ]]; then
    echo 1>&2 "Prefixed $PREFIX coreutils not found. Did you install a recent coreutils version ? Giving up."
    exit 1
fi

# Potential unowned symlinks:
# * chcon/runcon if USE=selinux for sys-apps/coretils but not app-alternaties/coreutils
# * /bin/* if USE=split-usr and installing app-alternatives with USE=uutils directly
TOOLS="[ arch base32 base64 basename basenc cat chgrp chmod chown chroot
	   cksum comm cp csplit cut date dd df dir dircolors dirname du echo
	   env expand expr factor false fmt fold head hostid id install join
	   link ln logname ls mkdir mkfifo mknod mktemp mv nice nl nohup
	   nproc numfmt od paste pathchk pinky pr printenv printf ptx pwd
	   readlink realpath rm rmdir seq shred shuf sleep sort split stat
	   stdbuf stty sum sync tac tail tee test timeout touch tr true
	   truncate tsort tty uname unexpand uniq unlink users vdir wc who
	   whoami yes
       b2sum md5sum sha1sum sha224sum sha256sum sha384sum sha512sum
       kill hostname chcon runcon"

# Helper to print/accumulate TODO
TODO=""
push() {
    printf "%-50s # %s\n" "$1" "$2"
    TODO="${TODO}$1\\n"
}

# Prepare the list of fixes: for each tool, look for the prefixed file
# in {/usr,}/bin and either create or overwrite the non-prefixed symlink.
for t in $TOOLS; do
    for d in /usr/bin /usr; do
        if [[ -f "${d}/${PREFIX}${t}" ]]; then
            want="${PREFIX}${t}"
            if [[ -f "${d}/${t}" ]]; then
                have=$(greadlink ${d}/${t})
                if [[ ! -h "${d}/${t}" ]]; then
                    push "" "Ignore non-symlink ${d}/${t}"
                elif [[ "$have" = "$want" ]]; then
                    push "" "Ignore correct ${d}/${t} -> ${want}"
                else
                    if $OVERWRITE; then
                        push "gln -fs $want ${d}/${t}" "Overwrite ${d}/${t} -> $have"
                    else
                        push "" "Ignore wrong-target ${d}/${t} -> ${have}"
                    fi
                fi
            else
                push "gln -s '$want' ${d}/${t}" "Create symlink"
            fi
        fi
    done
done

# Apply changes
echo -e "\nPress enter to run these commands, or Ctrl-C to abort"
read
echo -e "$TODO" | /usr/bin/bash
echo Done
