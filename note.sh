#!/usr/bin/env sh
# Append quick notes from the terminal into a daily note file.
#
# Usage:
#   note something you want to jot down   (appends the text to today's file)
#   pbpaste | note                        (appends piped/multiline input)
#   note                                  (opens today's file in your editor)
#
# Produces:
#   YYYY-MM-DD[.ext] in $NOTE_DIR (defaults to the current directory)
#   Extension comes from $NOTE_EXT (e.g. "txt" or "md"); unset = no extension.
set -o errexit

NOTE_DIR="${NOTE_DIR:-$(pwd)}"
mkdir -p "${NOTE_DIR}"

NOTE_EXT="${NOTE_EXT:-}"
if [ -n "${NOTE_EXT}" ]; then
  NOTE_EXT=".${NOTE_EXT#.}"
fi

NOTE_PATH="${NOTE_DIR}/$(date +%Y-%m-%d)${NOTE_EXT}"

if [ ${#} -gt 0 ]; then
  printf "%s\n" "${*}" >> "${NOTE_PATH}"
elif [ -p /dev/stdin ]; then
  cat >> "${NOTE_PATH}"
  printf "\n" >> "${NOTE_PATH}"
else
  "${EDITOR:-nano}" "${NOTE_PATH}"
fi
