if ! typeset -f ytr >/dev/null; then

	export PATH="$PATH:$HOME/.local/bin:$HOME/bin"

	# ── 2. Load .env files from ~/.environment.d/ ───────────────────
	# Automatically export all variables defined while sourcing .env files
	setopt allexport
	for file in ~/.environment.d/*.env(.N); do
	  source "$file"
	done
	unset file
	unsetopt allexport




	# Load a function that allows us to import other function definitions from
	# the ZSH_FUNC_PATH without providing their exact location
	source "$DOTFILES_DIR/.zsh_functions/autosource.sh"

	# Load the rest of the zsh configs in ~/.zshrc.d/
	setopt allexport
	for file in ~/.zshrc.d/*.zsh(.N); do
	    source "$file"
	done

	source ~/.zsh_functions/youtube.zsh  
fi

d () {
	local url="${1:-$(pbpaste)}"
	if [[ -z "$url" ]]; then
		echo "No URL provided and clipboard is empty."
		return 1
	fi
	case "$url" in
		(*youtube*|*youtu.be*) echo "Detected YouTube URL: $url"
			ytr "$url" ;;
		(*qobuz*) echo "Detected Qobuz URL: $url"
			mdl "$url" ;;
		(*) echo "Unknown URL: $url" ;;
	esac
}
mdl () {
cwd=$(pwd)
share_on_nas="192.168.84.3/media"
path_on_nas="Music/__INBOX"
check_smb_mount() {
    mount | grep -q "$mount_point"
}

mount_point="$HOME/NAS/Music"
if [ ! -d "$mount_point" ]; then
    echo "Creating mount point directory..."
    mkdir -p "$mount_point"
fi

if ! check_smb_mount; then
    echo "Mounting SMB share..."
    /sbin/mount_smbfs "smb://janolehuebner:$(pass sudo-lana)@$share_on_nas" "$mount_point"
fi

if ! check_smb_mount; then
    echo "Failed to mount SMB share. Exiting."
    exit 1
fi

# Move to target directory
cd "$mount_point/$path_on_nas"

echo "SMB share mounted successfully."
if [[ "$*" == *"tidal.com"* ]]; then
    echo "TIDAL DETECTED"
    tidal-dl -l $*
else
    echo "QOBUZ DETECTED"
    qobuz-dl dl $*
fi

echo "Unmounting SMB share..."
sleep 1
umount "$mount_point"
cd $cwd
open "http://bliss.lan/"
}
