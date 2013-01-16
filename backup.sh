#!/bin/sh

# Simple backup script
# Antti Laine <antti.a.laine@iki.fi>
#
# Not tested too well.
# Keep away from kittens and little children.
#
# Initial copy done with tar, because rsync sucks
# with huge amount of small files

# Here be settings
# ----------------

# Hostname of the remote machine to backup to.
# Use localhost when making a local copy
REMOTEHOST="localhost"

# Full directory path of the directory on the remote host to backup to.
# Must end with /
REMOTEDIR="/home/antti/backuptesti/backup/"

# List of directories to backup. Each directory must end with / (because: rsync)
BACKUPLIST="/home/antti/backuptesti/directory/"

# List of patterns for files and directories to exclude from the backup
#EXCLUDELIST="--exclude notthis --exclude northis"
EXCLUDELIST="--exclude antti/.VirtualBox --exclude antti/.wine"

# Magic begins. No touchy!
# ------------------------
current="$REMOTEDIR""current"
backup="$REMOTEDIR""backup-\$(stat -c %y $current)"

function show_help {
    echo "Usage: backup.sh [-i]
    -i  Do initial copy"
}

function backup {
    ssh "$REMOTEHOST" "cp -al \"$current\" \"$backup\""
    rsync -azv --progress --delete --delete-excluded $EXCLUDELIST $BACKUPLIST "$REMOTEHOST":"$current"
}

function init {
    tar -cv $EXCLUDELIST $BACKUPLIST | ssh "$REMOTEHOST" "tar --preserve-permissions --numeric-owner -xv -C \"$current\""
}

if test $# -eq 0; then
    backup
else
    if test "$*" == "-i"; then
        init
    else
        show_help
    fi
fi
