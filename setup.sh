#! /bin/sh

echo "Loading config folder in ${CONFIG=`dirname $(pwd)/$0`}"

SCRIPTS=${SCRIPTS:-$HOME/scripts}

link () {
  if ! [ -e "$HOME/$2" ]; then
    ln -s "$CONFIG/$1" "$HOME/$2"
    echo "$HOME/$2 --> $CONFIG/$1"
  fi
}

echo "Cloning Scripts repo"

if [ ! -e $SCRIPTS ]; then
  mkdir -p $SCRIPTS
  echo "Cloning scripts..."
  (cd $HOME && git clone git@bitbucket.org:nitnelave/scripts.git scripts)
fi

echo "Linking to config files..."

link vimrc .vimrc
link zshrc .zshrc-generic
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
if ! [ -e "$HOME/.gnupg/pubring.gpg" ]; then
  for i in `ls $SCRIPTS/gpg`; do
    ln -s $SCRIPTS/gpg/$i $HOME/.gnupg/$i
  done
  echo "$HOME/.gnupg --> $HOME/scripts/gpg"
fi

mkdir -p $HOME/.m2
if ! [ -e "$HOME/.m2/settings.xml" ]; then
  ln -s "$SCRIPTS/m2/settings.xml" "$HOME/.m2/settings.xml"
  echo "$HOME/.m2/settings.xml --> $HOME/scripts/m2/settings.xml"
fi

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

rm -rf "$HOME/.xinitrc-generic" "$HOME/.xsession-generic"


echo "Setting up lesskey..."
lesskey "$HOME/.lesskey"

echo "Cloning Vim plugins..."
mkdir -p $HOME/.vim
cd $HOME/.vim
if ! [ -e autoload/pathogen.vim ]; then
  echo "Cloning Pathogen..."
  git clone https://github.com/tpope/vim-pathogen.git
  mv vim-pathogen/* .
  rm -r vim-pathogen
  rm CONTRIBUTING.markdown README.markdown
fi
mkdir -p bundle
cd bundle
if ! [ -e clang_complete ]; then
  echo "Cloning Clang Complete..."
  git clone https://github.com/Rip-Rip/clang_complete.git
fi

if ! [ -e project ]; then
  echo "Downloading Project..."
  wget http://www.vim.org/scripts/download_script.php?src_id=6273 -O project.tar
  mkdir project
  (cd project && tar xf ../project.tar)
  rm project.tar
fi

if ! [ -e snipmate ]; then
  echo "Cloning Snipmate..."
  git clone https://github.com/msanders/snipmate.vim.git snipmate
fi

if ! [ -e vim-surround ]; then
  echo "Cloning Vim-surround..."
  git clone https://github.com/tpope/vim-surround.git
fi

if ! [ -e vim-repeat ]; then
  echo "Cloning Vim-repeat..."
  git clone https://github.com/tpope/vim-repeat.git
fi

if ! [ -e syntastic ]; then
  echo "Cloning Syntastic..."
  git clone https://github.com/scrooloose/syntastic.git
fi

if ! [ -e vim-fugitive ]; then
  echo "Cloning Fugitive..."
  git clone https://github.com/tpope/vim-fugitive.git
fi

if ! [ -e DoxygenToolkit.vim ]; then
  echo "Downloading DoxygenToolkit..."
  wget http://www.vim.org/scripts/download_script.php?src_id=14064 -O DoxygenToolkit.vim
fi

if ! [ -e AsyncCommand ]; then
  echo "Downloading AsyncCommand..."
  git clone https://github.com/pydave/AsyncCommand.git
fi

cd ..
if ! [ -e plugin/LanguageTool.vim ]; then
  echo "Cloning LanguageTool..."
  git clone https://github.com/vim-scripts/LanguageTool.git language
  mkdir -p plugin doc
  mv language/plugin/LanguageTool.vim plugin
  mv language/doc/LanguageTool.txt doc
  rm -r language
fi

if ! [ -e plugin/supertab.vim ]; then
  echo "Cloning Supertab..."
  wget http://www.vim.org/scripts/download_script.php?src_id=21752 -O /tmp/supertab.vmb
  vim /tmp/supertab.vmb +":source % | quit!"
  rm /tmp/supertab.vmb
fi


if ! [ -e ftplugin/tex_LatexBox.vim ]; then
  echo "Cloning LatexBox..."
  wget http://www.vim.org/scripts/download_script.php?src_id=16732 -O /tmp/latex.vmb
  vim /tmp/latex.vmb +":source % | quit!"
  rm /tmp/latex.vmb
  wget -O /tmp/latexSuite.tar.gz http://www.vim.org/scripts/download_script.php?src_id=2535
  tar xf /tmp/latexSuite.tar.gz
  mkdir -p $HOME/.vim/dictionaries
  cp /tmp/ftplugin/latex-suite/dictionaries/dictionary $HOME/.vim/dictionaries/
fi

if ! [ -e ~/.vimperator/colors/vimPgray.vimp ]; then
  mkdir -p ~/.vimperator/colors
  wget -O ~/.vimperator/colors/vimPgray.vimp   https://raw.githubusercontent.com/livibetter/dotfiles/master/vimperator/colors/vimPgray.vimp
fi

echo "Configuration successful!"
