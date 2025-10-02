#!/usr/bin/bash

set -e

# TODO: support split-usr

OVERWRITE=false
PRETEND=false

case $1 in
    -p)
        PRETEND=true
        ;;
    -o)
        OVERWRITE=true
        ;;
    -po)
        PRETEND=true;
        OVERWRITE=true
        ;;
    '')
        ;;
    *)
        echo "This script (re)creates symlinks to the gnu coreutils, to assist the transistion to app-alternatives"
        echo "Usage: $0 -p|-o|-po"
        echo " -p: Pretend mode: Don't actually make any change"
        echo " -o: Overwriet: Recreate symlinks if they already exist"
        exit
esac

if [[ ! -f /usr/bin/genv ]]; then
    echo 1>&2 "Prefixed gnu coreutils not found. Did you install a recent coreutils version ? Giving up."
    exit 1
fi


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

for t in $TOOLS; do
    if [[ -f /usr/bin/g${t} ]]; then
        if [[ ! -f /usr/bin/${t} ]]; then
            if [[ "$PRETEND" = true ]]; then
                echo "Pretend mode: would create /usr/bin/${t} -> g${t}"
            else
                echo "Creating /usr/bin/${t} -> g${t}"
                /usr/bin/gln -s "g${t}" "/usr/bin/${t}"
            fi
        elif [[ "$OVERWRITE" = true ]] && [[ -h /usr/bin/${t} ]]; then
            if [[ "$PRETEND" = true ]]; then
                echo "Pretend mode: would overwrite /usr/bin/${t} -> g${t}"
            else
                echo "Overwring /usr/bin/${t} -> g${t}"
                /usr/bin/gln -f -s "g${t}" "/usr/bin/${t}"
            fi
        fi
    fi
done
