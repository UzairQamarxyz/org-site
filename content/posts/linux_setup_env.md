+++
title = "Linux Setup: Services, Envs & Xorg"
author = ["Uzair Qamar"]
lastmod = 2024-02-19T19:53:20+05:00
tags = ["linux", "xdg", "systemd"]
draft = false
+++

## Overview {#overview}

Linux provides plenty of ways to start services on boot and set environment variables. From exporting variables in your shell rc files, to env files to environment.d to DE specific options, there are many wrong ways to do things and some right ways. With that being said, this is how I do things.


### Startup Services {#startup-services}

Largly inspired by NixOS, I use [systemd user services](https://wiki.archlinux.org/title/Systemd/User#Systemd_user_instance) (in systemd distros) to handle running programs at start. One benifit of this approach is that it is environment independant. Regardless of whether you're using a DE or a WM, these services always run.

To set up user services, simply create `.services` files in the `$XDG_CONFIG_HOME/systemd/user` folder. Here's one that I use.

-   `picom.service`

<!--listend-->

```shell
[Unit]
Description="Picom X11 compositor"
After=default.target

[Install]
WantedBy=default.target

[Service]
ExecStart=/usr/bin/picom
RestartSec=3
Restart=always
```

After creating the service just run `systemctl enable --user picom.service`. This service then should run next time you log in to your graphical environment.


### Environment Variables {#environment-variables}

I've had a lot of trouble setting up environment variables globally in the past and rightfully so. Many options exist for setting up environment variables; you have shell rc files (terrible approach imo), shell profiles, shell environment, environment.d, profile.d etc. You can read more about setting global environment variables in linux [here](https://wiki.archlinux.org/title/Environment_variables#Globally).

I primarily use `environment` to set environment variables. This ensures that my environment is shell agnostic.

I have quite a lot of environment variables. Most of them are to enforce [XDG Base Directory specification](https://wiki.archlinux.org/title/XDG_Base_Directory).

-   `/etc/environment`

<!--listend-->

```shell
export PATH="$PATH:$HOME/.local/bin"

QT_QPA_PLATFORMTHEME=gtk2
GTK_THEME=Flat-Remix-GTK-Blue-Dark
# Default programs:
EDITOR="nvim"
TERMINAL="alacritty"
TERMINAL_PROG="alacritty"
BROWSER="floorp"

# clean-up:
XDG_CONFIG_HOME="$HOME/.config"
XDG_CACHE_HOME="$HOME/.cache"
XDG_DATA_HOME="$HOME/.local/share"
XDG_STATE_HOME="$HOME/.local/state"
ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"

XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
USERXSESSION="$XDG_CACHE_HOME/X11/xsession"
USERXSESSIONRC="$XDG_CACHE_HOME/X11/xsessionrc"
ICEAUTHORITY="$XDG_CACHE_HOME/ICEauthority"
SCREENRC="$XDG_CONFIG_HOME/screen/screenrc"
ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"

GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
ZDOTDIR="$XDG_CONFIG_HOME/zsh"
GNUPGHOME="$XDG_DATA_HOME/gnupg"
WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
CARGO_HOME="$XDG_DATA_HOME/cargo"
GOPATH="$XDG_DATA_HOME/go"
GOMODCACHE="$XDG_CACHE_HOME/go/mod"
HISTFILE="$XDG_DATA_HOME/history"
PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
RUSTUP_HOME="$XDG_DATA_HOME"/rustup
AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME"/aws/credentials
AWS_CONFIG_FILE="$XDG_CONFIG_HOME"/aws/config

FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
QT_QPA_PLATFORMTHEME="gtk2" # Have QT use gtk2 theme.
MOZ_USE_XINPUT2="1" # Mozilla smooth scrolling/touchpads.

DOOMDIR="$XDG_CONFIG_HOME/doom"
```


### Xorg Configurations {#xorg-configurations}

The main things that I change are changing the keyboard variant, setting caps as an additional escape and increasing the autorepeat for the keyboard and disabling touchpad disable while typing option.

-   `00-keyboard.conf`

<!--listend-->

```shell
Section "ServerFlags"
   Option "DontZap" "false"
EndSection

Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "us"
        Option "XkbVariant" "dvorak"
        Option "XkbOptions" "terminate:ctrl_alt_bksp,caps:escape_shifted_capslock"
        Option "AutoRepeat" "200 10"
EndSection
```

-   `30-touchpad.conf`

<!--listend-->

```shell
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "DisableWhileTyping" "0"
EndSection
```
