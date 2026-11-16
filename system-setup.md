# System Setup

**OS:** Ubuntu 26.04-1

## Install Docker CE

```bash
# Install dependencies
sudo apt update
sudo apt install ca-certificates curl lsb-release gnupg util-linux-extra

# Add Docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu resolute stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine and Compose
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Run Docker without sudo
sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker $USER
newgrp docker
```

## Configure VRAM and GTT

1. Set UMA to 8GB in BIOS.

2. Set kernel memory parameters:

```bash
cat <<EOF | sudo tee /etc/sysctl.conf
vm.swappiness=10
vm.max_map_count=1048576
EOF
sudo sysctl -p
```

3. Allow unlimited memlock:

```bash
cat <<EOF | sudo tee /etc/security/limits.d/99-memlock.conf
*    soft    memlock   unlimited
*    hard    memlock   unlimited
EOF
```

4. Configure GTT table (~110GB for GPU, ~10GB reserved for OS):

```bash
cat <<EOF | sudo tee /etc/modprobe.d/amdgpu-strix.conf
options ttm pages_limit=28835840
options ttm page_pool_size=28835840
options amdttm pages_limit=28835840
options amdttm page_pool_size=28835840
EOF

# Append kernel parameters to GRUB_CMDLINE_LINUX_DEFAULT
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/&ttm.pages_limit=28835840 ttm.page_pool_size=28835840 amdttm.pages_limit=28835840 amdttm.page_pool_size=28835840 /' /etc/default/grub

sudo update-grub
sudo update-initramfs -u -k all
sudo reboot

# Verify after reboot
sudo dmesg | grep -E -i "amdgpu.*memory|GTT|TTM"
```

5. Install GPU monitoring tool:

```bash
wget https://github.com/Umio-Yasuno/amdgpu_top/releases/download/v0.11.5/amdgpu-top_without_gui_0.11.5-1_amd64.deb -O /tmp/amdgpu_top.deb
sudo apt install /tmp/amdgpu_top.deb
amdgpu_top
```

## Disable Desktop (headless mode)

```bash
# Set headless as default
sudo systemctl set-default multi-user.target

# Start desktop temporarily when needed
sudo systemctl start gdm3
```
