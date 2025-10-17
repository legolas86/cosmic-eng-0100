#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
# Proton VPN install
wget "https://repo.protonvpn.com/fedora-$(cat /etc/fedora-release | cut -d' ' -f 3)-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.3-1.noarch.rpm"
dnf5 -y install ./protonvpn-stable-release-1.0.3-1.noarch.rpm

dnf5 -y install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf5 -y install terra-release-extras ghostty starship
dnf5 config-manager setopt "terra*".enabled=0

  


# this installs a package from fedora repos
#dnf5 install -y tmux 
#dnf5 update -y
dnf5 group install -y --nobest base-graphical container-management core fonts hardware-support multimedia networkmanager-submodules printing development-tools c-development cosmic-desktop
# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

dnf5 -y install proton-vpn-gnome-desktop tmux code bootc wireshark podmansh tcpdump podman-machine podman-compose podman-tui virt-v2v tiptop qemu-kvm libvirt virt-install virt-manager toolbox distrobox flatpak tmux rust cargo rustup golang helix bat zoxide fzf tldr btop ripgrep rust rustup cargo fish
dnf5 clean all

#### Example for enabling a System Unit File

#libvirt group fix
#grep '^libvirt:' /usr/lib/group | tee -a /etc/group 
#wireshark fix
setcap cap_net_raw,cap_net_admin+eip /usr/bin/dumpcap

systemctl enable podman.socket
systemctl set-default graphical.target
#for drv in qemu network nodedev nwfilter secret storage interface; do systemctl start virt${drv}d{,-ro,-admin}.socket; done    