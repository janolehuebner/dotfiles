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

unset file
unsetopt allexport

autosource youtube
autosource milan
autosource nas
autosource fuck
autosource download

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


