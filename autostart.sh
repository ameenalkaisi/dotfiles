# this script is run by .xinitrc
# can be done any way though as long as it's a startup script that runs once
# on session manager login

HOME_DIR=/home/ameen; # set this

if [ $GDMSESSION == "dwm" ] ; then 
    setxkbmap -layout us,iq -option grp:alt_space_toggle;
    nitrogen --restore
    compton --config $HOME_DIR/.config/compton/compton.conf &
    $HOME_DIR/.dwm/autostart.sh &
fi
