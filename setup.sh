#! /bin/sh

echo "Loading config folder in ${CONFIG=`dirname $(pwd)/$0`}"

SCRIPTS?="$HOME/scripts"

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

mkdir -p $HOME/.i3
link i3config .i3/config
mkdir -p $HOME/.config/zathura
link zathurarc .config/zathura/zathurarc
link signature .signature
link slrnrc .slrnrc
link dircolors .dircolors
link vrapperrc .vrapperrc
link xsession .xsession
link xkb .xkb
link idea/ideavimrc .ideavimrc
link vimperatorrc .vimperatorrc
link Xdefaults .Xdefaults
link oh-my-zsh .oh-my-zsh
link "vim/RainbowParenthesis.vim" ".vim/plugin/RainbowParenthesis.vim"

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
copy xinitrc .xinitrc
copy zshrc .zshrc

echo "Setting up lesskey..."
lesskey $CONFIG/lesskey

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

if ! [ -e ~/.fzf ]; then
  git clone https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
  cp $CONFIG/fzf_shortcut.patch ~/.fzf
  (cd ~/.fzf && git apply fzf_shortcut.patch)
fi

if ! [ -e ~/.vimperator/colors/vimPgray.vimp ]; then
  mkdir -p ~/.vimperator/colors
  wget -O ~/.vimperator/colors/vimPgray.vimp   https://raw.githubusercontent.com/livibetter/dotfiles/master/vimperator/colors/vimPgray.vimp
fi

echo "Configuration successful!"
