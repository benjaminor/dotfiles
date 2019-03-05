# Packages required for setup

## PPA (Ubuntu 18.10) packages
- [Keepass XC](https://keepassxc.org/). PPA: ppa:phoerious/keepassxc
- [Firefox](https://www.mozilla.org/en-US/firefox/)
- [GNU Global](https://www.gnu.org/software/global/)
- [VLC Media Player](https://www.videolan.org/vlc/index.html)
- [Fish shell](https://fishshell.com/) PPA: ppa:fish-shell/release-3
- [Emacs](https://www.gnu.org/s/emacs/) PPA: ppa:kelleyk/emacs

Add repositories:

```console
$ sudo apt-add-repository ppa:fish-shell/release-3
$ sudo apt-add-repository ppa:phoerious/keepassxc
$ sudo add-apt-repository ppa:kelleyk/emacs
```

```console
$ sudo apt install keepassxc firefox global vlc fish emacs26
```

## Python

Using [Anaconda](https://anaconda.com) distribution with the Anaconda package manager.

### Libraries from PyPI
- bandit
- python-language-server
- black
- tox
- powerline-shell (for bash theme)
- pycodestyle
- flake8
- autopep8

```console
$ pip install bandit python-language-server[all] black tox powerline-shell pycodestyle flake8 autopep8
```


## [Nix Package Manager](https://nixos.org/nix/)

Install it with:

```console
$ curl https://nixos.org/nix/install | sh
```
### Packages installed with Nix:
- [ripgrep (rg)](https://github.com/BurntSushi/ripgrep)
- [bat](https://github.com/sharkdp/bat)
- [fzf](https://github.com/junegunn/fzf)
- [atool](https://www.nongnu.org/atool/)

## Fish-Shell and shell related stuff

Using [fisher](https://github.com/jorgebucaran/fisher) as package manager.
It is already included in the dotfiles repo.

### Packages used with fish:
- decors/fish-colored-man
- edc/bass
- jethrokuan/fzf
- jethrokuan/z
- laughedelic/pisces
- oh-my-fish/theme-bobthefish
- tuvistavie/fish-ssh-agent


## Node.js

Using [Node Version Manager (NVM)](https://github.com/creationix/nvm).

Install it with:
```console
$ curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
```

### Packages installed with Node.js:
- [tldr](https://github.com/tldr-pages/tldr)

## Texlive

Go to https://www.tug.org/texlive/acquire-netinstall.html and follow instructions.
