patreon() {
  ssh $NAS_USER@$NAS_IP "zsh /mnt/hdd/DATA/.scripts/patreon.sh"
}

fansly() {
    local users="$*"
    ssh $NAS_USER@$NAS_IP "cd /mnt/hdd/DATA/.scripts && echo $(pass $NAS_TOKEN_NAME_IN_STORE) | sudo -S ./fansly.sh \"$users\""
}

onlyfans() {
  ssh $NAS_USER@$NAS_IP "cd /mnt/hdd/DATA/.scripts && echo $(pass $NAS_TOKEN_NAME_IN_STORE) | sudo -S ./of.sh"
}

