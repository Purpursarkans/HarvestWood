#!/bin/sh
echo -ne '\033c\033]0;allinone\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/gameAll.x86_64" "$@"
