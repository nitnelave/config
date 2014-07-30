if [ -d $HOME/.xkb/keymap ]; then
  setxkbmap -print | \
  sed -e '/xkb_symbols/s/"[[:space:]]/+local+capslock(swapescape)&/' > $HOME/.xkb/keymap/custom
  xkbcomp -w0 -I$HOME/.xkb -R$HOME/.xkb keymap/custom $DISPLAY
fi
