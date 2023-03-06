# dotfiles
This repo contains general stuff I use in Linux. The directory is
assumed to be in ~/dotfiles. After this, symlink everything as necessary.

To symlink, do the following:
```
ln -s <source which would be in this git repo>
<destination based on instructions>
```

You can also use GNU stow for some configurations in Linux. Supported ones currently are:
- bash
- nvim
- tmux
- vim
- polybar
- dwm
- wezterm

Note that for windows, you can still "stow" them as long as $XDG_CONFIG_HOME is set to ~/.config in
the Environment variables. This is the way I'm doing it for WezTerm and Neovim now.

## for vim
Create ~/.vim/colors directories, and get candycolor from google then put
it in that directory

symlink the vimrc file to `~/.vimrc`

## for nvim
In windows, put it into `$env:LOCALAPPDATA/nvim` after installation, then
make sure Packer is properly installed and run :PackerSync inside of
nvim. In Linux, place it into `~/.config/nvim`, and do the same.

If you get something is not found error, it's probably an LSP server,
DAP, or formatter missing, all of them you can install through mason.

## for bash
Preferrably copy the files into home, then modify them as needed. This is
because they usually vary alot depending on OS and person so I think
it makes more sense this way instead of symlinking.

## for powershell
Need to install `TerminalIcons` module, `PSReadLine` module, and `oh-my-posh` (this
can be installed using chocolatey).

## for dwm
settings can be changed in config.h, or you can remove config.h, modify config.def.h, then run
```
sudo make clean install
```
