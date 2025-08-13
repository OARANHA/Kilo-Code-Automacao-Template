#!/usr/bin/env bash
set -euo pipefail
# uso:
#   pnpm run kread <path>                 # HEAD:200 (default)
#   pnpm run kread <path> ALL             # arquivo inteiro
#   pnpm run kread <path> HEAD:500        # primeiras 500 linhas
#   pnpm run kread <path> TAIL:300        # últimas 300 linhas
#   pnpm run kread <path> L:120-240       # intervalo 120..240
#   pnpm run kread <path> 1 400           # compat: start end
f="${1:?informe o caminho do arquivo}"
mode="${2:-HEAD:200}"
endarg="${3:-}"
# converte caminho Windows -> Unix (Git Bash)
if command -v cygpath >/dev/null 2>&1; then
  f="$(cygpath -u "$f")"
fi
strip_crlf() { sed $'s/\r$//'; }
read_all()         { sed -n '1,$p' "$f" | strip_crlf; }
read_head()        { local n="$1"; sed -n "1,${n}p" "$f" | strip_crlf; }
read_tail()        { local n="$1"; tail -n "$n" "$f" | strip_crlf; }
read_range()       { local a="$1" b="$2"; sed -n "${a},${b}p" "$f" | strip_crlf; }
# suporta ALL / HEAD:n / TAIL:n / L:a-b / start end
case "$mode" in
  ALL|all|'*')
    read_all
    ;;
  HEAD:*|head:*)
    n="${mode#*:}"; read_head "${n:-200}"
    ;;
  TAIL:*|tail:*)
    n="${mode#*:}"; read_tail "${n:-200}"
    ;;
  L:*|l:*)
    rng="${mode#*:}"
    a="${rng%-*}"; b="${rng#*-}"
    b="${b:-$}"   # se vazio, até o fim
    read_range "$a" "$b"
    ;;
  ''|*[!0-9]*)  # não numérico (fallback p/ HEAD:200)
    read_head 200
    ;;
  *)
    # modo compatível: start end (ex.: "1 400")
    start="$mode"
    b="$endarg"
    b="${b:-$}"   # se não passar 'end', vai até o fim
    read_range "$start" "$b"
    ;;
esac