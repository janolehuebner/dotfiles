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

    # Path to Brewfile
    BREWFILE="$HOME/.Brewfile"

    if ! command -v brew &>/dev/null; then
      echo "Homebrew not found. Installing..."
      
      if uname -r | grep -qi "truenas"; then
        mkdir $HOME/linuxbrew
        sudo ln -s $HOME/linuxbrew /home/linuxbrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      fi

      #----uv
      command -v uv >/dev/null 2>&1 || curl -LsSf https://astral.sh/uv/install.sh | sh
      #


      if [[ "$OSTYPE" == "darwin"* ]]; then

          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      

          if [[ -f "$BREWFILE" ]]; then
            echo "Installing from Brewfile: $BREWFILE"
            brew bundle --file="$BREWFILE"
          else
            echo "No Brewfile found at $BREWFILE"
          fi
      fi
    fi


}

