install_dotfiles () {
    echo "Installing stuff..."
    # vim-plug
    if ! [[ -f ~/.local/share/nvim/site/autoload/plug.vim ]]; then
      echo "Dotfiles: Downloading vim-plug..."
      if curl \
        --fail \
        --location \
        --retry 5 \
        --retry-delay 1 \
        --create-dirs \
        --progress-bar \
        --output ~/.local/share/nvim/site/autoload/plug.vim \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      then
        echo "Dotfiles: Done"
      else
        echo "Dotfiles: Error downloading vim-plug"
        dotfiles_install_error="yes"
      fi
    fi
}
