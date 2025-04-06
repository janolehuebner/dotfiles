rsize() {
  local dir=${1:-/mnt/Default/Ole/restic}  # Default to specified directory
  ssh mi.lan "source .zshrc && rsize"
}
