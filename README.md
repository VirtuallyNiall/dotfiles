# Niall's Dotfiles

These are the dotfiles I use across my systems.

## Setup Scripts

### Debian

```bash
git clone https://github.com/VirtuallyNiall/dotfiles.git
cd dotfiles
./setup-debian.sh
```

### Mac

```bash
git clone https://github.com/VirtuallyNiall/dotfiles.git
cd dotfiles
./setup-mac.sh
```

## Testing

Debian testing can be done through the provided dev container.
However, you'll need to change the shell from `bash` to `zsh`.
This can be achieved by editing this vscode setting:
```
"terminal.integrated.defaultProfile.linux": "zsh"
```

## Acknowledgements

- [Catppuccin Themes](https://github.com/catppuccin/catppuccin)