# System Setup
OS: Ubuntu 26.04-1

## How to install docker CE
```bash
# Install dependencies
sudo apt update
sudo apt install ca-certificates curl lsb-release gnupg util-linux-extra
# Fetch GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Set Up the Docker Repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu resolute stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# Install Docker Engine and Docker Compose
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Run docker without sudo
sudo groupadd docker # Optional
sudo usermod -aG docker $USER # Add logged user to the group
newgrp docker # Activate the changes immediately
```

## Configure VRAM and GTT table
1. Configure UMA to 8GB in BIOS
2. Update Kernel Parameters
```bash
cat <<EOF | sudo tee /etc/sysctl.conf
vm.swappiness=10
vm.max_map_count=1048576
EOF
sudo sysctl -p
```

3. Update memlock limits
```bash
cat <<EOF | sudo tee /etc/security/limits.d/99-memlock.conf
*    soft    memlock   unlimited
*    hard    memlock   unlimited
EOF
```

4. Configure GTT table to 110GB. Only 10GB left for the OS??
```bash
cat <<EOF | sudo tee /etc/modprobe.d/amdgpu-strix.conf
options ttm pages_limit=28835840
options ttm page_pool_size=28835840
options amdttm pages_limit=28835840
options amdttm page_pool_size=28835840
EOF

sudo vim /etc/default/grub
# Put below line into the file
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash amd_iommu=off ttm.pages_limit=28835840 ttm.page_pool_size=28835840 amdttm.pages_limit=28835840 amdttm.page_pool_size=28835840"
sudo update-grub
sudo update-initramfs -u -k all
sudo reboot

# Verify
sudo dmesg | grep -E -i "amdgpu.*memory|GTT|TTM"
```

5. Check the memory usage by the tool `amdgpu_top`
```bash
sudo wget https://github.com/Umio-Yasuno/amdgpu_top/releases/download/v0.11.5/amdgpu-top_without_gui_0.11.5-1_amd64.deb -O /tmp/amdgpu_top.deb
sudo apt install /tmp/amdgpu_top.deb
amdgpu_top
```

## Disable Desktop
```bash
# disable by default
sudo systemctl set-default multi-user.target
# Start Desktop temporarily
sudo systemctl start gdm3
```