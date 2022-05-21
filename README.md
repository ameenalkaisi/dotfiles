# dotfiles
This repo contains general stuff I use in Linux. The directory is 
assumed to be in ~/dotfiles. After this, symlink everything as necessary.

To symlink, do the following:
```
ln -s <source which would be in this git repo> 
<destination based on instructions>
```

## for vim
create ~/.vim/colors directories, and get candycolor from google then put 
it in that directory

symlink the vimrc file to ~/.vimrc

## for dwm
when compiling, remove config.h, compile, then apply the .diff file using 
the following command (file must
be in the same directory, try to symlink it): 
```
patch -p1 < config.h.diff
```
It will then prompt which file to apply it to, enter config.h, and it should be good

note also that this is the command to apply patches for .diff files in 
general (useful for patching suckless software)

autostart.sh file should be symlinked to a file where the autostart 
patch reads under, e.g., ~/.dwm/autostart.sh, change the 
variables as suitable to your location of where dwm's config file is 
and where you wanted to place this git directory. The autostart patch 
found in the [suckless website](https://dwm.suckless.org/patches/autostart/)

As of right now, autostart script could just be ran inside .xsessionrc
