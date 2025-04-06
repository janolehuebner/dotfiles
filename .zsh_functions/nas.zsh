patreon() {
  ssh janolehuebner@192.168.84.3 "zsh /mnt/hdd/DATA/.scripts/patreon.sh"
}

fansly () {
    local users="$*"
    ssh janolehuebner@192.168.84.3 "cd /mnt/hdd/DATA/.scripts && echo $(pass sudo-hannah) | sudo -S ./fansly.sh \"$users\""
}

onlyfans() {
  ssh janolehuebner@192.168.84.3 "cd /mnt/hdd/DATA/.scripts && echo $(pass sudo-hannah) | sudo -S ./of.sh"
}

