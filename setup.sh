#! /bin/sh

echo "Loading config folder in ${CONFIG=$HOME/config}"

link () {
  if ! [ -e $HOME/$2 ]; then
    ln -s $CONFIG/$1 $HOME/$2
    echo "$HOME/$2 --> $CONFIG/$1"
  fi
}

echo "Linking to config files..."

link vimrc .vimrc
link zshrc .zshrc-generic
link gitconfig .gitconfig-generic

mkdir -p $HOME/.i3
link i3config .i3/config
link signature .signature
link slrnrc .slrnrc
link vimperatorrc .vimperatorrc
link Xdefaults .Xdefaults
link oh-my-zsh .oh-my-zsh

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
  (cd project && tar xf project.tar)
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

echo "Configuration successful!"
