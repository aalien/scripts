#!/bin/sh

if test -z "$1"; then
    echo "Usage: $0 FILE [FFMPEGOPTS]"
    exit 1
fi

infile="$1"
shift
ffmpeg_opts="-r 30 -s 640x480 -vcodec libx264 -acodec libmp3lame -b:v 3M -b:a
128k $@"
basename="$(basename "$infile")"
outfile="${basename%.*}.mp4"

ffmpeg -i "$infile" $ffmpeg_opts "$outfile"
