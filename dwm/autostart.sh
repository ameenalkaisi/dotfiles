#!/bin/bash
# this script is run by .xsessionrc
# can be done any way though as long as it's a startup script that runs once
# on session manager login 

COMPTON_CONFIG=$HOME/.config/compton/compton.conf;
DOTFILES_DIR=$HOME/dotfiles;

setxkbmap -layout us,iq -option grp:alt_space_toggle;
nitrogen --restore;
compton --config $COMPTON_CONFIG &
$DOTFILES_DIR/dwm/status-bar.sh;
#dex -a;
