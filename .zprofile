export PATH="$PATH:$HOME/.local/bin:$HOME/bin"

# ── 2. Load .env files from ~/.environment.d/ ───────────────────
# Automatically export all variables defined while sourcing .env files
setopt allexport
for file in ~/.environment.d/*.env(.N); do
  source "$file"
done
unset file
unsetopt allexport

# ── 3. Source ~/.zshrc (if this is a login shell sourcing a profile file) ─
# In Zsh, this is unnecessary in most setups unless you separate login/init logic.
[[ -r ~/.zshrc ]] && source ~/.zshrc

