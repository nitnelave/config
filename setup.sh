#! /bin/sh

set -e

if [ $# -ge 1 ] && [ $1 = "-f" ]
then
  FORCE=1
fi

CONFIG="$(cd "$(dirname "$0")"; pwd -P)"
echo "Loading config folder in ${CONFIG}"

link () {
  [ "$FORCE" = "1" ] && rm -rf "$HOME/$2"
  if [ ! -e "$HOME/$2" ] && [ -e "$CONFIG/$1" ]; then
    mkdir -p `dirname "$HOME/$2"` \
      && ln -s "$CONFIG/$1" "$HOME/$2" \
      && echo "$HOME/$2 --> $CONFIG/$1"
  fi
}

echo "Linking config files..."

[ "$FORCE" = "1" ] && echo "Force mode enabled, recreating links"

#link vimrc .vimrc-generic
link nvim/lua .config/nvim/lua
link nvim/snippets .config/nvim/snippets
link zshrc .zshrc-generic
link bashrc .bashrc-generic
link dircolors .dircolors
link aliases .aliases
link gitconfig .gitconfig-generic
link gitignore-generic .gitignore

mkdir -p $HOME/.i3
link i3config .i3/config
mkdir -p $HOME/.config/zathura
link zathurarc .config/zathura/zathurarc
link xstart .xstart-generic
link xkb .xkb
#link idea/ideavimrc .ideavimrc
#link Xdefaults .Xdefaults
link lesskey .lesskey
link ssh_config .ssh/config-generic
link starship.toml .config/starship.toml

link vim/cheat40.txt .vim/cheat40.txt


if ! [ -e "$HOME/.xprofile" ]; then
  ln -s "$HOME/.xsession" "$HOME/.xprofile"
  echo "$HOME/.xprofile --> $HOME/.xsession"
fi

copy () {
  if ! [ -e $HOME/$2 ]; then
    cp $CONFIG/sample/$1 $HOME/$2
    echo "$CONFIG/sample/$1 --> $HOME/$2"
  fi
}

echo "Copying defaults..."

copy gitconfig .gitconfig
copy zshrc .zshrc
copy bashrc .bashrc
copy vimrc .vimrc
copy nvim.lua .config/nvim/init.lua
copy sshconfig .ssh/config

if ! [ -e $HOME/.urxvt/ext/font-size ]; then
  echo "Getting urxvt configuration"
  mkdir -p $HOME/.urxvt/ext
  wget https://raw.githubusercontent.com/majutsushi/urxvt-font-size/master/font-size -O $HOME/.urxvt/ext/font-size
fi

if ! [ -e "$HOME/.xstart" ]; then
  echo ". ./.xstart-generic" > "$HOME/.xstart"
fi

xinit () {
  if ! [ -e "$HOME/$1" ]; then
    echo ". ./.xstart" > "$HOME/$1"
  else
    if ! echo ". ./.xstart" | diff "$HOME/$1" -; then
      cat "$HOME/$1" >> "$HOME/.xstart"
      echo ". ./.xstart" > "$HOME/$1"
    fi
  fi
}

xinit .xsession
xinit .xinitrc
xinit .xsessionrc

echo "Installing misc tools"

if [ ! -e "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
   && $HOME/.fzf/install
fi

if [ ! -e "$HOME/.um-repo" ]; then
  git clone --depth 1 https://github.com/sinclairtarget/um.git ~/.um-repo \
    && mkdir -p ~/.bin \
    && ln -s ~/.bin/um ~/.um-repo/bin/um
fi

if [ ! -f "$HOME/.zsh/_git" ]; then
  mkdir -p ~/.zsh ~/.completion/git/
  wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash  -O ~/.completion/git/git-completion.sh
  wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh -O "$HOME/.zsh/_git"
fi

if [ ! -e ~/.zsh/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi

which rustup >/dev/null || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

if ! which nvim >/dev/null; then
  wget https://github.com/neovim/neovim/releases/download/v0.7.0/nvim-linux64.tar.gz -O /tmp/nvim.tar.gz
  tar xzvf /tmp/nvim.tar.gz -C ~/.bin
fi

which delta >/dev/null || cargo install git-delta
which rg >/dev/null || cargo install ripgrep

which direnv >/dev/null || sudo apt install direnv

curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir $HOME/.bin || true

echo "Configuration successful!"
