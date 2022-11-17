HOME_DIR=$HOME; # set this!

# this is probably the only important part, rest might be too specific
STARTCOLOR='\e[1;33m';
ENDCOLOR="\e[0m"
export PS1="\[$STARTCOLOR\][\@] \u@\h:\W\$ \[$ENDCOLOR\]"

# set vi editing mode
set -o vi
bind -m vi-insert "\C-l":clear-screen
. "$HOME/.cargo/env"
