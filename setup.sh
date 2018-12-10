#! /bin/sh

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
link signature .signature
link slrnrc .slrnrc
link dircolors .dircolors
link vrapperrc .vrapperrc
link xstart .xstart-generic
link xkb .xkb
link idea/ideavimrc .ideavimrc
link vimperatorrc .vimperatorrc
link pentadactylrc .pentadactylrc
link Xdefaults .Xdefaults
link oh-my-zsh .oh-my-zsh
link "vim/RainbowParenthesis.vim" ".vim/plugin/RainbowParenthesis.vim"
link lesskey .lesskey
link ssh_config .ssh/config

link vim/ftplugin .vim/ftplugin
link vim/ycm_extra_conf.py .vim/.ycm_extra_conf.py


if ! [ -e "$HOME/.weechat/irc.conf" ] || [ ! -h "$HOME/.weechat/irc.conf" ]; then
  mkdir -p "$HOME/.weechat"
  rm -f "$HOME/.weechat/irc.conf"
  ln -s "$CONFIG/weechat/irc.conf" "$HOME/.weechat/irc.conf"
  echo "$HOME/.weechat/irc.conf --> $CONFIG/weechat/irc.conf"
fi
mkdir -p "$HOME/.weechat"
link "weechat/irc.conf" ".weechat/irc.conf"

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

mkdir -p $HOME/.m2
link m2/settings.xml .m2/settings.xml

copy () {
  if ! [ -e $HOME/$2 ]; then
    cp $CONFIG/sample/$1 $HOME/$2
    echo "$CONFIG/sample/$1 --> $HOME/$2"
  fi
}

echo "Copying defaults..."

copy gitconfig .gitconfig
copy jnewsrc .jnewsrc
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

rm -rf "$HOME/.xinitrc-generic" "$HOME/.xsession-generic"


if [ -L "$HOME/.vimrc" ]
then
  rm "$HOME/.vimrc"
  echo "source $HOME/.vimrc-generic" > "$HOME/.vimrc"
fi

echo "Setting up lesskey..."
lesskey "$HOME/.lesskey"

if [ ! -e ~/.nvim/dein ]; then
  echo "Setting up Dein..."
  mkdir -p ~/.nvim
  curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/installer.sh
  sh /tmp/installer.sh ~/.nvim/dein
fi

echo "Installing misc tools"

if [ -f "$HOME/.local/bin/thefuck" ]; then
  pip3 uninstall -y thefuck || sudo pip3 uninstall -y thefuck
fi

if [ ! -e "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
   && $HOME/.fzf/install
fi

if [ ! -e "$HOME/.um-repo" ]; then
  git clone --depth 1 https://github.com/sinclairtarget/um.git ~/.um-repo \
    && mkdir -p ~/.bin \
    && ln -s ~/.bin/um ~/.um-repo/bin/um
fi

echo "Configuration successful!"
