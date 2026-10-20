# dotfiles

NixOS + Home Manager configuration, niri's settings and the Emacs
configuration, all written in ONE literate file: `config.org`.

**Edit `config.org`, never the generated files.** Saving `config.org` in
Emacs (or running `tangle` in a shell) writes every file listed below; each
starts with a "GENERATED from config.org" line. Commit `config.org` and the
generated files together: Nix and a fresh install use the generated files
directly, without Emacs.

```
config.org                     THE SOURCE: everything below except the marked files
flake.nix                      inputs (stable + unstable nixpkgs, Home Manager, ...) and machines
nixos/
  configuration.nix            core: Nix, pkgs.unstable, users, locale, Home Manager wiring
  modules/hardware.nix         boot, firmware, graphics, sound, network, power, disks
  modules/desktop.nix          niri, login screen, fonts, printing, Flatpak
  modules/programs.nix         system-wide programs, nix-ld
  hosts/nixusb/default.nix     the USB test installation
  hosts/nixusb/hardware-configuration.nix   NOT from config.org: written by the installer (copy in, git add)
home/
  home.nix                     Home Manager entry point: imports the files below
  shell.nix                    bash, aliases, prompt, git, gh, tmux, CLI and Nix tools
  terminal.nix                 Alacritty (default) and foot
  apps.nix                     private applications, WhatsApp Web launcher
  browser.nix                  LibreWolf and default applications
  dev.nix                      uv, language servers, LaTeX
  emacs.nix                    Emacs 31 with packages from emacs/config.el; the daemon
  desktop.nix                  niri session: launcher, notifications, lock, idle, look, scripts
  waybar.nix                   the bar
  niri/config.kdl              niri settings (live-linked: edits apply on save)
  email.nix                    optional: Microsoft 365 mail for mu4e (off by default)
  work.nix                     optional: a second account for work (off by default)
emacs/config.el                Emacs configuration (loaded by the init.el stub)
flake.lock                     NOT from config.org: written by Nix; commit it
README.md, .gitattributes      NOT from config.org: edited directly
```

The everyday cycle (PDF, chapter 20):

```
C-c i  (or: cfg)               open config.org in Emacs
edit, C-x C-s                  save = tangle: all generated files rewritten
rebuild                        apply Nix changes (niri applies its own at once)
C-x g, S, c c, C-c C-c, P p  commit config.org + generated files, push
other machine: git pull, rebuild
```

Everyday commands (aliases from home/shell.nix):

```
rebuild        nh os switch              build and switch
update         nh os switch --update     update flake.lock, then switch; commit flake.lock
rebuild-boot   nh os boot                build; use it from the next boot
gens           nh os info                list generations
nh clean all --keep 5                    remove old generations
sudo nixos-rebuild switch --flake ~/dotfiles#nixusb    the same as rebuild, without nh
```

New files must be `git add`-ed before a rebuild, or the flake cannot see them.
A new tangle target (a new section with its own `:tangle` file) is such a new file.
