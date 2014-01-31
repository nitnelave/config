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


echo "Configuration successful!"
