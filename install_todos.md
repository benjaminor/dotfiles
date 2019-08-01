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

## Small helpful programs
- ncdu
- gcal

## Python

Using [Anaconda](https://anaconda.com) distribution with the Anaconda package manager.

### Libraries from PyPI
- python-language-server (but using microsoft's python-language-server now)
- black
- tox
- powerline-shell (for bash theme)
- flake8, autopep8, pycodestyle, mypy, bandit

```console
$ pip install bandit python-language-server[all] black tox powerline-shell pycodestyle flake8 autopep8, mypy
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
- [fd](https://github.com/sharkdp/fd)

## Fish-Shell and shell related stuff

Using [fisher](https://github.com/jorgebucaran/fisher) as package manager.
It is already included in the dotfiles repo.

### Packages used with fish:

See the [fishfile](fish/fishfile)
