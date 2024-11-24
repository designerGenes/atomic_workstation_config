manbat() {
  man "$@" | col -bx | bat --paging=always --language=man
}
