# DMS & Niri
[Dux Labs](https://duxlabs.dev/docs/)
[Niri Wiki](https://niri-wm.github.io/niri/)

## Installation

```bash
sudo apt update && sudo apt upgrade -y
sudo add-apt-repository ppa:duxlabs/dux-repo
sudo add-apt-repository ppa:duxlabs/dms
sudo apt update
sudo apt install -y niri dms alacritty xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
                    kimageformat6-plugins qt6-image-formats-plugins
```

## Setup
```bash
dms setup
#
# Privilege Escalation Tool: sudo
# Compositor: Niri
# Terminal: Alacritty
# Use systemd for session management: Yes
#
# After Setup
dms doctor
systemctl --user status dms
```

