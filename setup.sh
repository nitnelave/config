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

echo "Cloning Vim plugins..."
mkdir -p $HOME/.vim/bundle
cd $HOME/.vim/bundle

remove_plugin () {
    if [ -e $1 ]; then
      echo "Removing $1"
      rm -rf $1
    fi
}

for plugin in vim-fugitive \
              AsyncCommand \
              clang_complete \
              project \
              DoxygenToolkit \
              snipmate \
              syntastic \
              ../plugin/remoteOpen.vim
do
    remove_plugin $plugin
done

clone_plugin () {
    if ! [ -e $1 ]; then
      echo "Cloning $1 ..."
      shift
      git clone $@
    fi
}

clone_plugin supertab https://github.com/ervandew/supertab.git

clone_plugin vim-surround https://github.com/tpope/vim-surround.git

clone_plugin rust.vim --depth=1 https://github.com/rust-lang/rust.vim.git rust.vim

clone_plugin vim-repeat https://github.com/tpope/vim-repeat.git

clone_plugin vim-localvimrc https://github.com/embear/vim-localvimrc.git

clone_plugin ultisnips https://github.com/SirVer/ultisnips.git

clone_plugin vim-snippets https://github.com/honza/vim-snippets.git

clone_plugin ctrlp.vim https://github.com/ctrlpvim/ctrlp.vim.git

clone_plugin ctrlp-py-matcher https://github.com/FelikZ/ctrlp-py-matcher

clone_plugin vim-paste-easy https://github.com/roxma/vim-paste-easy.git

clone_plugin file-line https://github.com/bogado/file-line.git

clone_plugin gitsessions https://github.com/wting/gitsessions.vim

if ! [ -e YouCompleteMe ]; then
    echo "Cloning YouCompleteMe"
    git clone --recursive https://github.com/Valloric/YouCompleteMe.git
    YCM_FLAGS=--clang-complete
    if $(which cargo >/dev/null 2>/dev/null); then
        YCM_FLAGS="$YCM_FLAGS --racer-completer"
        clone_plugin YouCompleteMe/rust --depth=1 https://github.com/rust-lang/rust.git YouCompleteMe/rust
    fi
    (cd YouCompleteMe && ./install.py $YCM_FLAGS )
    pip install python_levenshtein
fi

cd ..

if ! [ -e autoload/pathogen.vim ]; then
  echo "Cloning Pathogen..."
  git clone https://github.com/tpope/vim-pathogen.git
  mv vim-pathogen/* .
  rm -r vim-pathogen
  rm CONTRIBUTING.markdown README.markdown
fi

if ! [ -e plugin/LanguageTool.vim ]; then
  echo "Cloning LanguageTool..."
  git clone https://github.com/vim-scripts/LanguageTool.git language
  mkdir -p plugin doc
  mv language/plugin/LanguageTool.vim plugin
  mv language/doc/LanguageTool.txt doc
  rm -r language
fi


if ! [ -e ftplugin/tex_LatexBox.vim ]; then
  echo "Cloning LatexBox..."
  wget http://www.vim.org/scripts/download_script.php?src_id=16732 -O /tmp/latex.vmb \
   && vim /tmp/latex.vmb +":source % | quit!" \
   && rm /tmp/latex.vmb \
   && wget -O /tmp/latexSuite.tar.gz http://www.vim.org/scripts/download_script.php?src_id=2535 \
   && tar xf /tmp/latexSuite.tar.gz \
   && mkdir -p $HOME/.vim/dictionaries \
   && cp /tmp/ftplugin/latex-suite/dictionaries/dictionary $HOME/.vim/dictionaries/
fi

remove_plugin "~/.vimperator/colors/vimPgray.vimp"

if ! [ -e ftdetect/markdown.vim ]; then
  echo "Cloning Markdown..."
  wget http://www.vim.org/scripts/download_script.php?src_id=15150 -O /tmp/markdown.vba.gz \
   && (cd /tmp && gzip -d markdown.vba.gz) \
   && vim /tmp/markdown.vba +":source % | quit!" \
   && patch ~/.vim/syntax/markdown.vim < "$CONFIG/markdown.diff"
fi

if [ -f "$HOME/.local/bin/thefuck" ]; then
  pip3 uninstall -y thefuck || sudo pip3 uninstall -y thefuck
fi

if [ ! -d "$HOME/.fzf" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
   && $HOME/.fzf/install
else
  (cd $HOME/.fzf && git pull && ./install)
fi

if [ ! -d "$HOME/.um-repo" ]; then
  git clone --depth 1 https://github.com/sinclairtarget/um.git ~/.um-repo \
    && mkdir -p ~/.bin
    && ln -s ~/.bin/um ~/.um-repo/bin/um
fi

echo "Configuration successful!"
