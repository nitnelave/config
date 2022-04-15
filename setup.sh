#! /bin/sh

set -e

if [ $# -ge 1 ] && [ $1 = "-f" ]
then
  FORCE=1
fi

echo "Loading config folder in ${CONFIG=`dirname $(pwd)/$0`}"

SCRIPTS=${SCRIPTS:-$HOME/scripts}

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

link vimrc .vimrc-generic
link zshrc .zshrc-generic
link bashrc .bashrc-generic
link aliases .aliases
link gitconfig .gitconfig-generic
link gitignore-generic .gitignore

mkdir -p $HOME/.i3
link i3config .i3/config
mkdir -p $HOME/.config/zathura
link zathurarc .config/zathura/zathurarc
#link signature .signature
link xstart .xstart-generic
link xkb .xkb
#link idea/ideavimrc .ideavimrc
#link Xdefaults .Xdefaults
#link oh-my-zsh .oh-my-zsh
link lesskey .lesskey
link ssh_config .ssh/config

link vim/ftplugin .vim/ftplugin
link vim/cheat40.txt .vim/cheat40.txt


if ! [ -e "$HOME/.xprofile" ]; then
  ln -s "$HOME/.xsession" "$HOME/.xprofile"
  echo "$HOME/.xprofile --> $HOME/.xsession"
fi

mkdir -p $HOME/.gnupg
if ! [ -e "$HOME/.gnupg/pubring.gpg" ] && [ -e "$SCRIPTS/gpg" ]; then
  for i in `ls $SCRIPTS/gpg`; do
    ln -s $SCRIPTS/gpg/$i $HOME/.gnupg/$i
  done
  echo "$HOME/.gnupg --> $HOME/scripts/gpg"
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

echo "Configuration successful!"
