# dotfiles
This repo contains general stuff I use in Linux

## for vim
create ~/.vim/colors directories, and get candycolor from google then put it in that directory

## for dwm
when compiling, remove config.h, compile, then apply the .diff file using the following command (file must
be in the same directory, try to symlink it): 
```
patch -p1 < config.h.diff
```
It will then prompt which file to apply it to, enter config.h, and it should be good
