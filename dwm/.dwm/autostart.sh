#!/bin/bash
# this script is run by .xsessionrc
# can be done any way though as long as it's a startup script that runs once
# on session manager login 

PICOM_CONFIG=$HOME/.config/picom/picom.conf;
DOTFILES_DIR=$HOME/dotfiles;

setxkbmap -layout us,iq -option grp:alt_space_toggle;
nitrogen --set-zoom-fill --random ~/opt/wallpapers --save;
picom --config $PICOM_CONFIG &
polybar -c ~/.config/polybar/config.ini example&
#$DOTFILES_DIR/dwm/status-bar.sh;
#dex -a;
