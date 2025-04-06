# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


