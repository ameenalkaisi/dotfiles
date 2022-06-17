HOME_DIR=$HOME; # set this!

# possibly able to remove some things here
export LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH;
export WEKAINSTALL=/opt/weka-3-9-6/;
export CLASSPATH=/opt/java/jdbc/ojdbc11.jar:/opt/weka-3-9-6/weka.jar:$WEKAINSTALL;
export PATH=$HOME_DIR/.npm-global/bin:/$HOME_DIR/opt/android-studio/bin:/$HOME_DIR/.local/bin:/opt/Qt/6.2.4/gcc_64/bin:/$HOME_DIR/opt/bin:/opt/cmake-3.23.1-linux-x86_64/bin:$PATH;
export NPM_CONFIG_PREFIX=$HOME_DIR/.npm-global;
export GEM_HOME=$HOME/.gem;
export PYTHONPATH=$HOME_DIR/.local/lib:$PYTHONPATH;

# this is probably the only important part, rest might be too specific
STARTCOLOR='\e[1;33m';
ENDCOLOR="\e[0m"
export PS1="\[$STARTCOLOR\][\@] \u@\h:\W\$ \[$ENDCOLOR\]"

# set vi editing mode
set -o vi
bind -m vi-insert "\C-l":clear-screen
