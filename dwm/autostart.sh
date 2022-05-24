#!/bin/bash
# this script is run by .xsessionrc
# can be done any way though as long as it's a startup script that runs once
# on session manager login

# set the following
HOME_DIR=$HOME;
DOTFILES_DIR=$HOME/dotfiles;

setxkbmap -layout us,iq -option grp:alt_space_toggle;
nitrogen --restore;
compton --config $HOME_DIR/.config/compton/compton.conf &
$DOTFILES_DIR/dwm/status-bar.sh &
dex -s ~/.config/autostart -a
