#!/usr/bin/env zsh

selected=$(
  {
    find "$HOME" -mindepth 1 -maxdepth 2 -type d 2>/dev/null
    [[ -n "$WIN" ]] && find "$WIN" -mindepth 1 -maxdepth 3 -type d 2>/dev/null
  } | fzf --preview 'tree -a -L 3 -C -F --prune --filesfirst {}'
)

if [[ -n "$selected" ]]; then
    cd "$selected" || exit
    [[ "$1" == "-v" ]] && nvim .
fi
