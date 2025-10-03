mkcd() {
  mkdir -p "$1" && cd "$1"
}
extract() {
  [ -f "$1" ] && case "$1" in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.tar.xz) tar xJf "$1" ;;
    *.zip) unzip "$1" ;;
    *) echo "Unknown archive format: $1" ;;
  esac
}
