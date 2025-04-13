function insta() {
    local cwd=$(pwd)

    check_smb_mount() {
        /sbin/mount | grep -q "$insta_mount_point"
    }

    local stories_only=false
    local user_list=()

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --cron)
                local random_wait=$((RANDOM % 1800))
                echo "--------------------------------------------"
                echo "Waiting for $((random_wait / 60)) minutes..."
                sleep $random_wait
                stories_only=true
                ;;
            --stories)
                stories_only=true
                ;;
            *)
                user_list+=("$1")
                ;;
        esac
        shift
    done
    echo "-----$(date)------"
    if [ ! -d "$insta_mount_point" ]; then
        echo "Creating mount point directory..."
        mkdir -p "$insta_mount_point"
    fi

    if ! check_smb_mount; then
        echo "Mounting SMB share..."
        /sbin/mount_smbfs "smb://janolehuebner:$(pass sudo-lana)@$insta_share_on_nas" "$insta_mount_point"
    fi

    if ! check_smb_mount; then
        echo "Failed to mount SMB share. Exiting."
        return 1
    fi

    cd "$insta_mount_point/$insta_path_on_nas" || return 1

    # Use default users if no user was specified
    if [[ ${#user_list[@]} -eq 0 ]]; then
        user_list=("${insta_default_users[@]}")
    fi

    # Build the instaloader command
    local cmd=(uvx --with browser_cookie3 instaloader -b Safari -B "$insta_cookiefile" "${user_list[@]}" --fast-update)

    if $stories_only; then
        cmd+=(--stories --no-profile-pic --no-posts)
    else
        cmd+=(--stories --reels)
    fi

    "${cmd[@]}"

    echo "Unmounting SMB share..."
    sleep 3
    /sbin/umount -f "$insta_mount_point"
    cd "$cwd"
}
