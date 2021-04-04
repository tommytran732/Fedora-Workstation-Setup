#!/bin/bash

#Please note that this is how I PERSONALLY setup my computer - I do some stuff such as not using anything to download GNOME extensions from extensions.gnome.org and installing the extensions as a package instead
#Customize it to your liking
#Run this script as your user, NOT root

#Written by yours truly, Tomster

#Variables
USER=$(whoami)

output(){
    echo -e '\e[36m'$1'\e[0m';
}

#Moving to the home directory
#Note that I always use /home/${USER} because gnome-terminal is wacky and sometimes doesn't load the environment variables in correctly (Right click somewhere in nautilus, click on open in terminal, then hit create new tab and you will see.)
cd /home/${USER} || exit

#Setting umask to 077
umask 077
sudo sed -i 's/UMASK		022/UMASK		077/g' /etc/login.defs
sudo sed -i 's/#umask 022/umask 077/g' /etc/profile

#Disable ptrace
sudo cp /usr/lib/sysctl.d/10-default-yama-scope.conf /etc/sysctl.d/
sudo sed -i 's/kernel.yama.ptrace_scope = 0/kernel.yama.ptrace_scope = 3/g' /etc/sysctl.d/10-default-yama-scope.conf
sudo sysctl --load=/etc/sysctl.d/10-default-yama-scope.conf

#Enable UFW
sudo ufw enable

#Update packages and firmware
sudo apt update
sudo apt upgrade -y
sudp apt autoremove -y
sudo fwupdmgr get-devices
sudo fwupdmgr refresh --force
sudo fwupdmgr get-updates
sudo fwupdmgr update -y

#Remove unneeded packages
sudo apt purge gnome-calculator *evince* *seahorse* *gedit* *yelp* gnome-screenshot gnome-power-manager eog gnome-logs gnome-characters gnome-shell-extension-desktop-icons gnome-font-viewer *file-roller* cups* printer-driver* network-manager-pptp* network-manager-openvpn* *nfs* aaport* telnet *spice* tcpdump firefox* gnome-disk* gnome-initial-setup ubuntu-report popularity-contest whoopsie speech-dispatcher modemmanager avahi* gnome-shell-extension-ubuntu-dock -y
sudo apt autoremove -y
sudo snap remove snap-store

#Install packages that I use
sudo dnf -y install neofetch git-core flat-remix-gtk3-theme libappindicator-gtk3 gnome-shell-extension-appindicator gnome-shell-extension-system-monitor-applet gnome-shell-extension-dash-to-dock gnome-shell-extension-freon gnome-shell-extension-openweather gnome-shell-extension-user-theme gnome-tweak-tool f29-backgrounds-gnome gnome-system-monitor nautilus gvfs-mtp gvfs-goa git-core fireja tuned-gtk git-core
sudo add-apt-repository ppa:alexlarsson/flatpak -y
sudo apt update
sudo apt upgrade -y
sudo apt -y install neofetch gnome-software flatpak gnome-software-plugin-flatpak firejail apparmor-profiles apparmor-profiles-extra apparmor-utils gnome-tweak-tool arc-theme

#Install Yubico StuffNetworkManager-config-connectivity-fedora
sudo apt -y install yubikey-manager pam-u2f pamu2fcfg
mkdir -p /home/${USER}/.config/Yubico

#Install IVPN
curl -fsSL https://repo.ivpn.net/stable/ubuntu/generic.gpg | sudo apt-key add - 
curl -fsSL https://repo.ivpn.net/stable/ubuntu/generic.list | sudo tee /etc/apt/sources.list.d/ivpn.list 
sudo apt update
sudo apt upgrade -y
sudo apt install ivpn-ui -y

#Install OpenSnitch
sudo dnf install -y https://github.com/evilsocket/opensnitch/releases/download/v1.3.6/opensnitch-1.3.6-1.x86_64.rpm
sudo dnf install -y https://github.com/evilsocket/opensnitch/releases/download/v1.3.6/opensnitch-ui-1.3.6-1.f29.noarch.rpm
sudo chmod -R $USER:USER /home/${USER}/.config/autostart

#Setup VSCodium
sudo rpm --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg 
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg" |sudo tee -a /etc/yum.repos.d/vscodium.repo 
sudo dnf install -y codium
sudo cp /etc/firejail/vscodium.profile /etc/firejail/codium.profile
sudo chmod 644 /etc/firejail/codium.profile

#Setting up Flatpak
flatpak remote-add --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --user flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
flatpak remove --unused

#Install default applications
flatpak install flathub com.github.tchx84.Flatseal org.mozilla.firefox org.videolan.VLC org.gnome.eog org.gnome.Calendar org.gnome.Contacts org.gnome.FileRoller com.yubico.yubioath -y

#Enable auto TRIM
sudo systemctl enable fstrim.timer

#Enable Firejail
sudo firecfg

#Download and set GNOME shell theme
git clone https://github.com/i-mint/midnight.git
mkdir /home/${USER}/.themes
ln -s /home/${USER}/midnight/Midnight-* /home/${USER}/.themes/
gsettings set org.gnome.shell.extensions.user-theme name "Midnight-Blue"

#Download and set icon theme
git clone https://github.com/NicoHood/arc-icon-theme.git
mkdir /home/${USER}/.icons 
ln -s /home/${USER}/arc-icon-theme/Arc /home/${USER}/.icons/
git clone https://github.com/zayronxio/Mojave-CT.git
ln -s /home/${USER}/Mojave-CT /home/${USER}/.icons/
sed -i 's/Inherits=Moka,Adwaita,gnome,hicolor/Inherits=Mojave-CT,Moka,Adwaita,gnome,hicolor/g' /home/${USER}/arc-icon-theme/Arc/index.theme
find /home/${USER}/arc-icon-theme -name '*[Tt]rash*' -exec rm {} \;
find /home/${USER}/Mojave-CT -name '*[Nn]autilus*' -exec rm {} \;
find /home/${USER}/Mojave-CT -name '*[Gg]nome.[Ss]ettings*' -exec rm {} \;
find /home/${USER}/Mojave-CT -name '*[Gg]nome.[Tt]weak*' -exec rm {} \;
find /home/${USER}/Mojave-CT -name '*[Gg]nome.[Ss]oftware*' -exec rm {} \;
find /home/${USER}/Mojave-CT -name '*[Gg]nome.[Bb]oxes*' -exec rm {} \;
find /home/${USER}/Mojave-CT -name '*[Ss]team*' -exec rm {} \;
find /home/${USER}/Mojave-CT -name '*[Tt]hunderbird*' -exec rm {} \;
find /home/${USER}/Mojave-CT -name '*[Mm]inecraft*' -exec rm {} \;
find /home/${USER}/Mojave-CT -name '*[Ee]piphany*' -exec rm {} \;
gsettings set org.gnome.desktop.interface icon-theme "Arc"

#Set GTK theme
gsettings set org.gnome.desktop.interface gtk-theme "Flat-Remix-GTK-Blue-Dark"
flatpak upgrade -y

#Set Fedora 29 Animated Wallpaper
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/f29/default/f29.xml'

#Set Black GDM background
mkdir -p /home/${USER}/Pictures/Wallpapers/
wget https://wallpaperaccess.com/full/512679.jpg -O /home/${USER}/Pictures/Wallpapers/Black.png
sudo dnf -y copr enable zirix/gdm-wallpaper
sudo dnf -y install gdm-wallpaper
sudo set-gdm-wallpaper /home/${USER}/Pictures/Wallpapers/Black.png
(sudo crontab -l ; echo "@reboot /usr/bin/set-gdm-wallpaper /home/${USER}/Pictures/Wallpapers/Black.png >> /dev/null 2>&1")| sudo crontab -

#Enable Titlebar buttons
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

#Quick Fix for Freon https://github.com/UshakovVasilii/gnome-shell-extension-freon/issues/163
sudo sed -i 's#`${nvme}#`/usr/bin/sudo ${nvme}#g' /usr/share/gnome-shell/extensions/freon@UshakovVasilii_Github.yahoo.com/nvmecliUtil.js
echo ''"${USER}"'   ALL = NOPASSWD: /usr/sbin/nvme list -o json, /usr/sbin/nvme smart-log /dev/nvme* -o json' | sudo EDITOR='tee -a' visudo >/dev/null 2>&1

#Enable GNOME shell extensions
gsettings set org.gnome.shell disable-user-extensions false

#Enable tap to click
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

#Reenable Wayland... They are working to support it, and if you aren't gaming you shouldn't stay on x11 anyways
sudo sed -i 's^DRIVER=="nvidia", RUN+="/usr/libexec/gdm-disable-wayland"^#DRIVER=="nvidia", RUN+="/usr/libexec/gdm-disable-wayland"^g' /usr/lib/udev/rules.d/61-gdm.rules

#Randomize MAC address
sudo bash -c 'cat > /etc/NetworkManager/conf.d/00-macrandomize.conf' <<-'EOF'
[device]
wifi.scan-rand-mac-address=yes

[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
connection.stable-id=${CONNECTION}/${BOOT}
EOF

sudo systemctl restart NetworkManager


