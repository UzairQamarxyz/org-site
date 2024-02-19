+++
title = "Linux Setup: Window Manager (Suckless Edition)"
author = ["Uzair Qamar"]
lastmod = 2024-02-19T15:38:05+05:00
tags = ["linux", "dwm", "dwmblocks", "dmenu"]
draft = false
+++

## Overview {#overview}

I've created this blog for my own sanity, I have been using these tools for a long time now but haven't actually bothered documenting on what modifications I have made and why I have made them. This sometimes comes to bite me in the back, especially when I migrate to a new system.

At the time of writing, this is what my desktop looks like. Here I'm using the [kanagawa](https://github.com/rebelot/kanagawa.nvim/) colorscheme. I'll talk about `ricing` in another blog.

{{< figure src="/images/2024-02-19_15-31.png" caption="<span class=\"figure-number\">Figure 1: </span>Current Rice" class="big" >}}


### Window Manager [dwm] {#window-manager-dwm}

[Source](https://github.com/uzairqamarxyz/dwm.git)

I don't use a Desktop Manager due to their excessive dependence on mouse-centric actions. Instead, I opt for a extensively patched version of  [dwm](https://dwm.suckless.org/), a dynamic tiling window manager. dwm allows me to work in a keyboard-centric environment, resulting in greater speed and efficiency.

Here are some patches &amp; modifications I use.


#### Patches {#patches}

-   [adjacenttag](https://dwm.suckless.org/patches/adjacenttag/): This patch allow to focus on the adjacent tag (left or right) or move a client to it.
-   [attachbelow](https://dwm.suckless.org/patches/attachbelow/): Make new clients attach below the selected client, instead of always becoming the new master
-   [autostart](https://dwm.suckless.org/patches/autostart/): Runs `~/.local/share/dwm/{autostart, autostart_blocking}.sh` before starting dwm.
-   [cursorwarp-mononly](https://dwm.suckless.org/patches/cursorwarp/): Warp the cursor to the center of the target window when switching between monitors.
-   [alpha-fixborders](https://dwm.suckless.org/patches/alpha/): Fixes transparent borders when using a compositor.
-   [fullgaps](https://dwm.suckless.org/patches/fullgaps/): Adds gaps between clients and screen farmes.
-   [inplacerotate](https://dwm.suckless.org/patches/inplacerotate/): Shifts the ordering of clients in the master/stack area.
-   [notitle](https://dwm.suckless.org/patches/notitle/): Removes title area from the statusbar.
-   [pertag](https://dwm.suckless.org/patches/pertag/): Enables pertag layouts, barpos, nmaster and mwfact.
-   [restartsig](https://dwm.suckless.org/patches/restartsig/): Allows you to restart dwm.
-   [preserveonrestart](https://dwm.suckless.org/patches/preserveonrestart/): Preservers tags for clients when dwm restarts.
-   [xrdb](https://dwm.suckless.org/patches/xrdb/): Allows dwm to read colors from `xrdb (.Xresources)` at run time.
-   [sgrstatus](https://dwm.suckless.org/patches/sgrstatus/): Allows the use of CSI SGR escape sequences in the status bar text to change text rendition.


#### Tweaks {#tweaks}

> config.def.h

```C++
// General Appearance
static const unsigned int borderpx  = 0;        /* border pixel of windows */
static const unsigned int gappx     = 10;       /* gaps between windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int horizpadbar        = 0;        /* horizontal padding for statusbar */
static const int vertpadbar         = 8;        /* vertical padding for statusbar */
static const char *fonts[]          = { "IosevkaCustom Nerd Font:size=12" };
static const char dmenufont[]       = "IosevkaCustom Nerd Font:size=12";

static const char *tags[] = {" ", "󰈹 ", "󰉋 ", "󰝚 ", "󰎁 ", "󰈙 ", "󰒱 "};

/* Snip */

// Commands
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = {"dmenu_run", "-m", dmenumon, NULL};
static const char *termcmd[]  = { "alacritty", NULL };
static const char *emacs[]  = { "emacsclient", "-c", "-a", "'emacs'", NULL };
static const char *browser[]  = { "librewolf", NULL };
static const char *ranger[] = {"alacritty", "-e", "ranger", NULL};
static const char *cmus[] = {"alacritty", "-e", "cmus", NULL};
static const char *nmtui[]  = { "alacritty", "-e", "nmtui", NULL };
static const char *lockscreen[]  = { "betterlockscreen", "--lock", NULL };
static const char *screenshot[]  = { "flameshot", "gui", NULL };
static const char *brightnessup[]  = { "brightnessctl", "set", "10%+", NULL };
static const char *brightnessdown[]  = { "brightnessctl", "set", "10%-", NULL };

/* Snip */

// Custom Keybinds
static const Key keys[] = {
    /* modifier                     key                       function        argument */
    { MODKEY,                       XK_d,                     spawn,          {.v = dmenucmd } },
    { MODKEY,                       XK_Return,                spawn,          {.v = termcmd } },
    { MODKEY,                       XK_e,                     spawn,          {.v = ranger} },
    { MODKEY,                       XK_c,                     spawn,          {.v = cmus} },
    { MODKEY,                       XK_w,                     spawn,          {.v = browser}},
    { MODKEY|ShiftMask,             XK_w,                     spawn,          {.v = nmtui}},
    { MODKEY,                       XK_x,                     spawn,          {.v = lockscreen}},
    { 0,                            XF86XK_Calculator,        spawn,          {.v = emacs} },
    { 0,                            XK_Print,                 spawn,          {.v = screenshot} },
    { MODKEY,                       XK_BackSpace,             spawn,          SHCMD("sysact")},
    { MODKEY,                       XK_p,                     spawn,          SHCMD("cmus-remote --pause && pkill -RTMIN+20 dwmblocks")},
    { MODKEY,                       XK_bracketleft,           spawn,          SHCMD("cmus-remote --prev && pkill -RTMIN+20 dwmblocks")},
    { MODKEY|ShiftMask,             XK_bracketleft,           spawn,          SHCMD("cmus-remote --seek -10 && pkill -RTMIN+20 dwmblocks")},
    { MODKEY,                       XK_bracketright,          spawn,          SHCMD("cmus-remote --next && pkill -RTMIN+20 dwmblocks")},
    { MODKEY|ShiftMask,             XK_bracketright,          spawn,          SHCMD("cmus-remote --seek +10 && pkill -RTMIN+20 dwmblocks")},
    { 0,                            XF86XK_AudioMute,         spawn,          SHCMD("amixer set Master toggle && pkill -RTMIN+10 dwmblocks")},
    { 0,                            XF86XK_AudioRaiseVolume,  spawn,          SHCMD("amixer set Master 5%+ && pkill -RTMIN+10 dwmblocks")},
    { 0,                            XF86XK_AudioLowerVolume,  spawn,          SHCMD("amixer set Master 5%- && pkill -RTMIN+10 dwmblocks")},
    { 0,                            XF86XK_MonBrightnessUp,   spawn,          {.v = brightnessup}},
    { 0,                            XF86XK_MonBrightnessDown, spawn,          {.v = brightnessdown}},
}
```


#### Scripts {#scripts}

-   [sysact](https://github.com/UzairQamarxyz/dotfiles/blob/master/.local/bin/sysact)


### Dynamic Launcher [dmenu] {#dynamic-launcher-dmenu}

[Source](https://github.com/uzairqamarxyz/dmenu.git)

I use [dmenu](https://tools.suckless.org/dmenu/) as my launcher. Here are the patches I use for my dmenu.


#### Patches {#patches}

-   [center](https://tools.suckless.org/dmenu/patches/center/): Centers dmenu in the middle of  the screen.
-   [fuzzymatch](https://tools.suckless.org/dmenu/patches/fuzzymatch/): Adds support for fuzzy-matching.
-   [grid](https://tools.suckless.org/dmenu/patches/grid/): Enables grid layout.
-   [line height](https://tools.suckless.org/dmenu/patches/line-height/): Allows for setting a minimum height for the dmenu line.
-   [xresources](https://tools.suckless.org/dmenu/patches/xresources/): Enables dmenu configuration through `.Xresources`.


#### Tweaks {#tweaks}

> config.def.h

```C++
static int topbar = 0;                      /* -b  option; if 0, dmenu appears at bottom     */
static int centered = 1;                    /* -c option; centers dmenu on screen */
static int min_width = 600;                 /* minimum width when centered */
static int fuzzy = 1;                       /* -F  option; if 0, dmenu doesn't use fuzzy matching     */
static char font[] = "monospace:size=10";
static const char *fonts[] = {
	font,
	"monospace:size=10"
};
static char *prompt      = NULL;      /* -p  option; prompt to the left of input field */

/* Snip */

static unsigned int lines      = 7;
static unsigned int columns    = 1;
static unsigned int lineheight = 26;
static unsigned int min_lineheight = 26;
```


### Status Bar [dwmblocks-async] {#status-bar-dwmblocks-async}

[Source](https://github.com/uzairqamarxyz/dwmblocks.git)

The vanilla dwm bar is quite limited in terms of aesthetics and functionality, so I use [dwmbar-async](https://github.com/UtkarshVerma/dwmblocks-async).


#### Scripts {#scripts}

-   [cmus](https://github.com/uzairqamarxyz/dotfiles/master/.local/bin/sb-cmus)
-   [network](https://github.com/uzairqamarxyz/dotfiles/master/.local/bin/sb-network)
-   [volume](https://github.com/uzairqamarxyz/dotfiles/master/.local/bin/sb-volume)
-   [battery](https://github.com/uzairqamarxyz/dotfiles/master/.local/bin/sb-battery)
-   [time](https://github.com/uzairqamarxyz/dotfiles/master/.local/bin/sb-time)
