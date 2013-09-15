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
