#! /bin/sh

DIRECTION=${1-right}

display () {
  PRIMARY=$1
  xrandr --output $PRIMARY --auto
  while [ $# -gt 1 ]; do
    xrandr --output $2 --off
    xrandr --output $2 --$DIRECTION-of $PRIMARY --auto
    shift
  done
}

SCREENS=`xrandr | grep -E " connected (primary )?[1-9]+" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/"`
display $SCREENS
