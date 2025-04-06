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

    if [[ ! -d ~/.oh-my-zsh ]]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/themes/powerlevel10k
    fi



}

