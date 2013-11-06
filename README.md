config
======

various config files (dvorak)

us_keyboard is the us file situated in
/usr/share/X11/xkb/symbols/ for debian
/usr/share/syscons/symbols/ for bsd

Xorg conf:
edit xorg.conf :
Section "InputDevice"
    Identifier    "Keyboard0"
    Driver        "kbd"
    Option        "XkbLayout" "us.dvorak"
EndSection

FreeBSD: kdbmap us.dvorak
Debian: setxkbmap dvorak

Caps Lock -> Escape
edit ~/.Xmodmap
!! No Caps Lock
clear lock
!! Make Caps_lock an escape key.
keycode 0x42 = Escape

Caps Lock <-> Escape
setxkbmap -option -option caps:swapescape

less: For the "less" pager, the configuration file for the bindings is lesskey.
Simply running "lesskey lesskey" will setup your pager.
