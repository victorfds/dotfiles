# Dotfiles

Personal config for this Arch Linux desktop on Hyprland (Lua, 0.56+).

The current rice is illogical-impulse, the Quickshell `qs -c ii` shell from [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland) (`main`). Docs: [ii.clsty.link](https://ii.clsty.link/en/ii-qs/01setup/).

This repo is not a fork of illogical-impulse. It only stores what I changed on top of a stock install: `~/.config/hypr/custom/`, terminal overlays, editor overlays, and a few other files the installer should leave alone.

AUR packages go through [paru](https://github.com/Morganamilo/paru) 2.x. This machine does not have `yay`.

---

## What this machine runs

| Piece | Current use |
|---|---|
| Distro | Arch Linux rolling |
| Compositor | Hyprland (Hyprland session, never UWSM) |
| Desktop shell | illogical-impulse / Quickshell (`qs -c ii`) |
| Login | SDDM Qt6, [3d3f/ii-sddm-theme](https://github.com/3d3f/ii-sddm-theme), Wayland greeter (`kwin_wayland`) |
| Terminal | Kitty with fish (ii default) |
| Prompt | Starship |
| Browser | Firefox via `firefox -P` (`Super + W`) |
| Editor | Code - OSS (`code`); NvChad and LunarVim on the side |
| Node | nvm in `~/.config/nvm` (default v24) and corepack |
| AUR | `paru` |
| Host GPU | AMD (`amdgpu`) |
| Guest GPU | NVIDIA RTX 3080 on VFIO (`vfio-pci.ids=10de:2216,10de:1aef`) + QEMU/libvirt |

Right Alt is Compose (`compose:ralt`). Timezone: `America/Campo_Grande`.

---

## illogical-impulse (base)

Install as in the wiki. On this machine the clone lives in `~/dots-hyprland` (the GitHub folder name). `~/.cache/dots-hyprland` is a symlink to that directory.

```bash
git clone https://github.com/end-4/dots-hyprland.git ~/dots-hyprland \
  --filter=blob:none --recurse-submodules
cd ~/dots-hyprland
git checkout main
```

Upstream `sdata/dist-arch/install-deps.sh` calls `yay`. I switch those calls to `paru` before `./setup install`. The script does not install `yay-bin`.

```bash
# in install-deps.sh: yay -> paru  (do not clone yay-bin)
./setup install
```

Then, by hand, in `/etc/pacman.conf`:

```
IgnoreGroup=illogical-impulse
```

To update, from the clone:

```bash
cd ~/dots-hyprland
git stash
git pull
# re-apply the paru patch in install-deps.sh if stash dropped it
./setup install
```

The installer's rsync does not delete `custom/`.

- Code: [github.com/end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)
- Setup: [ii.clsty.link/en/ii-qs/01setup](https://ii.clsty.link/en/ii-qs/01setup/)
- Config: [ii.clsty.link/en/ii-qs/03config](https://ii.clsty.link/en/ii-qs/03config/)
- Official overlay: `~/.config/hypr/custom/*.lua`

---

## What I changed on top of stock

Whatever ii already installs (`hyprland.lua`, `hyprland/`, `hypridle.conf`, stock `config.fish`, ii's Starship) stays where `./setup` put it. Below is only the delta.

### Hyprland (`hypr/custom/`)

| File | ii default | Here |
|---|---|---|
| `variables.lua` | browser via `launch_first_available.sh` (Chrome first) | `browser = "firefox -P"` on `Super + W` |
| `general.lua` | empty | `kb_options = "compose:ralt"` |
| `keybinds.lua` | only opens the file itself | Print / `code:107` / `Super+Shift+S` run `scripts/screenshot.sh` (grimblast, file and clipboard) |
| `execs.lua` | empty | on start: kills `kded6`, `plasmashell`, and `nm-applet` (the `kded` package stays; the daemon fights Quickshell for the tray) |

### ii shell (`illogical-impulse/config.json`)

Automatic night light from 17:30 to 06:30 at 2200 K. ii's default is 19:00-06:30; in Campo Grande the sun sets around 17:29. This does not read GPS. It is `light.night.from` and `to` in [Config.qml](https://github.com/end-4/dots-hyprland/blob/main/dots/.config/quickshell/ii/modules/common/Config.qml).

`conflictKiller.autoKillTrays` and `autoKillNotificationDaemons` are on (kded6 and KDE trays). `panelFamily` is `ii`.

GTK and Qt use ii's theme (`adw-gtk3-dark`, `breeze-plus-dark` icons, `Bibata-Modern-Classic` cursor), not HyDE's Tokyo-Night.

### Terminal (Kitty + fish)

ii already launches Kitty with `shell fish`. On top of that:

| Overlay | What it does |
|---|---|
| `kitty/kitty.conf` | `cursor_trail 0`, `window_margin_width 2.75` (stock ii: trail 1, margin 21.75) |
| `fish/conf.d/git.fish` | OMZ-style shortcuts: `gst`, `gp`, `gl`, `gco`, `gcmsg`, … |
| `fish/conf.d/nvm.fish` + `functions/bass.fish` | nvm (`~/.config/nvm`) and corepack in fish |
| `fish/conf.d/uv.env.fish` | PATH from [uv](https://github.com/astral-sh/uv) |

### Code - OSS (`vscode/`)

Current User `settings.json` from `~/.config/Code - OSS/User/`. Rust and Leptos (rust-analyzer, leptosfmt, inlay hints), Vitesse Dark / Vitesse Light, Catppuccin Mocha icons, Input Mono and JetBrainsMono Nerd Font.

### Neovim, NvChad overlay (`nvim/`)

Stock [NvChad starter](https://github.com/NvChad/starter) files stay with the install (`init.lua`, `lua/options.lua`, `lua/configs/lazy.lua`, `lua/configs/conform.lua`, lockfile). This repo only has the overlay:

| File | What it does |
|---|---|
| `lua/chadrc.lua` | theme `pastelbeans` |
| `lua/mappings.lua` | `;` to `:`, `jk` to Escape, `<leader>ih` toggles inlay hints |
| `lua/plugins/init.lua` | snacks, leetcode (Rust), spectre, rstml, trouble, hover, and related plugins |
| `lua/configs/lspconfig.lua` | html, cssls, tailwindcss, rust-analyzer with clippy, leptosfmt, and Leptos proc-macro ignores |

### LunarVim (`lvim/`)

Stock LunarVim files stay with the install. This repo only has the user files:

| File | What it does |
|---|---|
| `config.lua` | Neovim 0.12 shims, rust_analyzer / ts_ls / vue_ls, snacks, crates.nvim, rstml |
| `lsp-settings/rust_analyzer.json` | clippy, leptosfmt, inlay hints, Leptos proc-macro ignores |

---

## Repo map

| In this repo | Goes to |
|---|---|
| `hypr/custom/` | `~/.config/hypr/custom/` |
| `fish/` | `~/.config/fish/` (`conf.d`, `functions`) |
| `kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |
| `illogical-impulse/config.json` | `~/.config/illogical-impulse/config.json` |
| `gtk-3.0/`, `gtk-4.0/` | same under `~/.config` |
| `vscode/settings.json` | `~/.config/Code - OSS/User/settings.json` |
| `nvim/lua/` | `~/.config/nvim/lua/` (overlay only) |
| `lvim/config.lua` | `~/.config/lvim/config.lua` |
| `lvim/lsp-settings/` | `~/.config/lvim/lsp-settings/` |
| `starship/`, `alacritty/`, `hyde/` | leftovers from earlier rices; not the current session |

---

## Applying these overlays (after `./setup install` with paru)

```bash
# Hyprland user overlay (ii does not --delete custom/)
rsync -a hypr/custom/ ~/.config/hypr/custom/

# Fish (Kitty)
rsync -a fish/conf.d/ ~/.config/fish/conf.d/
rsync -a fish/functions/ ~/.config/fish/functions/

# Kitty, GTK, ii settings
cp -a kitty/kitty.conf ~/.config/kitty/kitty.conf
cp -a gtk-3.0/settings.ini ~/.config/gtk-3.0/settings.ini
cp -a gtk-4.0/settings.ini ~/.config/gtk-4.0/settings.ini
cp -a illogical-impulse/config.json ~/.config/illogical-impulse/config.json

# Editors
mkdir -p ~/.config/"Code - OSS"/User ~/.config/nvim/lua/configs ~/.config/lvim/lsp-settings
cp -a vscode/settings.json ~/.config/"Code - OSS"/User/settings.json
cp -a nvim/lua/chadrc.lua nvim/lua/mappings.lua ~/.config/nvim/lua/
cp -a nvim/lua/plugins/init.lua ~/.config/nvim/lua/plugins/init.lua
cp -a nvim/lua/configs/lspconfig.lua ~/.config/nvim/lua/configs/lspconfig.lua
cp -a lvim/config.lua ~/.config/lvim/config.lua
cp -a lvim/lsp-settings/rust_analyzer.json ~/.config/lvim/lsp-settings/rust_analyzer.json
```

Extra packages for the overlays (paru, no yay):

```bash
paru -S --needed grimblast-git nvm  # nvm may already live in ~/.config/nvm
# hyprsunset, grim, slurp, wl-clipboard, hyprland, sddm: come from ./setup install
```

Reload Quickshell with `Ctrl + Super + R` (`qs -c ii`). Reload Hyprland with `hyprctl reload`.

---

## Not in this repo (this machine only)

VFIO and QEMU use the cmdline `vfio-pci.ids=10de:2216,10de:1aef`. Leave that alone.

SDDM uses [ii-sddm-theme](https://github.com/3d3f/ii-sddm-theme) and `/etc/sddm.conf.d/zz-ii-sddm-wayland.conf` (`DisplayServer=wayland`, `kwin_wayland`). I removed the greeter's Suspend button: on resume, login kwin loses DRM and SDDM does not start the greeter again. `/etc/systemd/system-sleep/sddm-greeter-resume` covers the case where the machine still sleeps on the login screen.

In pacman: `IgnoreGroup=illogical-impulse`.
