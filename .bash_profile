HOME_DIR = /home/ameen; # set this!

# possibly able to remove some things here
export LD_LIBRARY_PATH=/usr/local/lib64:$LD_LIBRARY_PATH;
export WEKAINSTALL=/opt/weka-3-9-6/;
export CLASSPATH=/opt/java/jdbc/ojdbc11.jar:/opt/weka-3-9-6/weka.jar:$WEKAINSTALL;
export PATH=$HOME_DIR/.npm-global/bin:/home/ameen/opt/android-studio/bin:/home/ameen/.local/bin:/opt/Qt/6.2.4/gcc_64/bin:/home/ameen/opt/bin:/opt/cmake-3.23.1-linux-x86_64/bin:$PATH;
export NPM_CONFIG_PREFIX=$HOME_DIR/.npm-global;
export GEM_HOME=$HOME/.gem;
export PYTHONPATH=$HOME_DIR/.local/lib:$PYTHONPATH;

STARTCOLOR='\e[1;33m';
ENDCOLOR="\e[0m"
export PS1="\[$STARTCOLOR\][\@] \u@\h:\W\$ \[$ENDCOLOR\]"
