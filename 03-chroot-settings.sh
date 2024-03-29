#!/bin/bash
source configuration.txt

mount none -t proc /proc
mount none -t sysfs /sys
mount none -t devpts /dev/pts
export HOME=/root
export LC_ALL=C
echo $DISTRO_HOSTNAME > /etc/hostname 

cat <<EOF > /etc/apt/sources.list
deb http://ua.archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
deb-src http://ua.archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
deb http://ua.archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse
deb-src http://ua.archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse
deb http://ua.archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse
deb-src http://ua.archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse
EOF

apt-get update

apt-get install -y libterm-readline-gnu-perl systemd-sysv


dbus-uuidgen > /etc/machine-id
ln -fs /etc/machine-id /var/lib/dbus/machine-id
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl

apt-get -y upgrade

apt-get install -y \
    sudo \
    ubuntu-standard \
    casper \
    lupin-casper \
    discover \
    laptop-detect \
    os-prober \
    network-manager \
    resolvconf \
    net-tools \
    wireless-tools \
    wpagui \
    locales \
    grub-common \
    grub-gfxpayload-lists \
    grub-pc \
    grub-pc-bin \
    grub2-common \
    nano \
    screenfetch \
    wget \
    vim \
    less \
    git \
    iputils-ping \
    memtest86+


apt-get install -y --no-install-recommends linux-generic
#apt-get install -y grub-efi-ia32
#vernut posle VirtualBox
#apt-get install -y grub-efi-amd64

#XFCE
apt install xorg lightdm liblightdm-gobject-1-0 lightdm-gtk-greeter lightdm-gtk-greeter-settings xfce4 xfwm4 -y
#Vishe bil firefox
apt-get install thunar-archive-plugin plymouth-theme-ubuntu-logo -y
apt-get install xfce4-goodies -y

#UBIQUITY:Podhodid dlya gnome i dlya xfce
apt-get install -y \
   ubiquity \
   ubiquity-casper \
   ubiquity-frontend-gtk \
   ubiquity-slideshow-ubuntu \
   ubiquity-ubuntu-artwork

#Ubiquity config:##########################################################################
cat <<EOF > /languagelist.data
0:en:English:English
2:uk:Ukrainian:Українська
EOF

gzip /languagelist.data
rm -rf /usr/lib/ubiquity/localechooser/languagelist.data.gz
mv /languagelist.data.gz /usr/lib/ubiquity/localechooser/languagelist.data.gz
#############################################################################################
    
apt-get purge -y \
    transmission-gtk \
    transmission-common \
    gnome-mahjongg \
    gnome-mines \
    gnome-sudoku \
    aisleriot \
    hitori
apt-get remove --purge gnome*
apt-get autoremove -y


dpkg-reconfigure locales

apt-get clean

#Splash image
cp 200.png /usr/share/plymouth/ubuntu-logo.png
cp 200.png /usr/share/plymouth/themes/spinner/watermark.png
cp 200.png /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.png
cp 200.png /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo16.png
chmod 777 /usr/share/plymouth/ubuntu-logo.png
chmod 777 /usr/share/plymouth/themes/spinner/watermark.png
chmod 777 /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo.png
chmod 777 /usr/share/plymouth/themes/ubuntu-logo/ubuntu-logo16.png
update-initramfs -u

#Start icon
cp xfce4-panel-menu\(16\).png /usr/share/icons/hicolor/16x16/apps/xfce4-panel-menu.png
cp xfce4-panel-menu\(22\).png /usr/share/icons/hicolor/22x22/apps/xfce4-panel-menu.png
cp xfce4-panel-menu\(24\).png /usr/share/icons/hicolor/24x24/apps/xfce4-panel-menu.png
cp xfce4-panel-menu\(32\).png /usr/share/icons/hicolor/32x32/apps/xfce4-panel-menu.png
cp xfce4-panel-menu\(48\).png /usr/share/icons/hicolor/48x48/apps/xfce4-panel-menu.png
cp xfce4-panel-menu\(48\).png /usr/share/icons/elementary-xfce/apps/48/xfce4-panel-menu.png
chmod 777 /usr/share/icons/hicolor/16x16/apps/xfce4-panel-menu.png
chmod 777 /usr/share/icons/hicolor/22x22/apps/xfce4-panel-menu.png
chmod 777 /usr/share/icons/hicolor/24x24/apps/xfce4-panel-menu.png
chmod 777 /usr/share/icons/hicolor/32x32/apps/xfce4-panel-menu.png
chmod 777 /usr/share/icons/hicolor/48x48/apps/xfce4-panel-menu.png
chmod 777 /usr/share/icons/elementary-xfce/apps/48/xfce4-panel-menu.png

#Wallpaper
cp wallpaper.png /usr/share/backgrounds/xfce/xfce-stripes.png
cp wallpaper.jpg /usr/share/backgrounds/xfce/xfce-blue.jpg
cp wallpaper.jpg /usr/share/backgrounds/xfce/xfce-teal.jpg
chmod 777 /usr/share/backgrounds/xfce/xfce-stripes.png
chmod 777 /usr/share/backgrounds/xfce/xfce-blue.jpg
chmod 777 /usr/share/backgrounds/xfce/xfce-teal.jpg

#Themes
rm -rf /usr/share/themes/Greybird
rm -rf /usr/share/themes/Default
cp -ra theme /usr/share/themes/Greybird
cp -ra theme /usr/share/themes/Default
chmod 777 /usr/share/themes/Greybird
chmod 777 /usr/share/themes/Default

#Icons
rm -rf /usr/share/icons/elementary-xfce-dark
rm -rf /usr/share/icons/default
cp -ra icons /usr/share/icons/elementary-xfce-dark
cp -ra icons /usr/share/icons/default
chmod 755 /usr/share/icons/elementary-xfce-dark
chmod 755 /usr/share/icons/default



cat <<EOF > /etc/lightdm/lightdm.conf
[SeatDefaults]
greeter-hide-users=true
allow-guest=false
EOF

cat <<EOF > /etc/lightdm/lightdm-gtk-greeter.conf
[greeter]
background=/usr/share/backgrounds/xfce/xfce-stripes.png
default-user-image=/usr/share/plymouth/ubuntu-logo.png
EOF

apt install apparmor-utils apparmor-profiles -y
apt install cups -y
apt install system-config-printer-gnome -y
apt install libreoffice-base libreoffice-calc libreoffice-draw libreoffice-impress libreoffice-math libreoffice-writer -y
apt-get install -y \
ubuntu-restricted-extras \
hunspell-ru \
hunspell-uk \
ttf-mscorefonts-installer \
hyphen-en-us \
hyphen-ru \
hyphen-uk \
unrar-free \
uudeview \
vlan \
vlc \
inkscape \
vdpauinfo \
wavpack \
wbritish \
wukrainian \
laptop-mode-tools \
fonts-wqy-microhei \
fonts-wqy-zenhei \
g++ \
gcc \
gdebi-core \
gimp \
gimp-help-ru \
gimp-data-extras \
gimp-help-en \
printer-driver-all \
printer-driver-all-enforce \
printer-driver-cups-pdf \
printer-driver-oki \
pinta \
proxychains4 \
acpi \
acpitool \
libosmesa6 \
libpam-modules \
libpam-encfs \
arj \
autopoint \
bleachbit \
bluetooth \
xfonts-75dpi \
xfonts-100dpi \
libatomic1 \
libc6-dbg \
browser-plugin-freshplayer-pepperflash \
cpu-x \
cryptmount \
dash \
dh-modaliases \
rar \
libreoffice-avmedia-backend-gstreamer \
libreoffice-help-ru \
libreoffice-help-en-us \
libreoffice-l10n-uk \
libreoffice-librelogo \
libreoffice-lightproof-en \
libreoffice-lightproof-ru-ru \
libreoffice-sdbc-hsqldb \
libreoffice-style-galaxy \
libreoffice-systray \
libreoffice-templates \
libc6-i386 \
libd3dadapter9-mesa-dev \
libdbusmenu-gtk4 \
linux-libc-dev \
ecryptfs-utils \
lshw-gtk \
fatattr \
ffmpeg \
mc \
mdadm \
findutils \
mesa-utils-extra \
mesa-utils \
mesa-va-drivers \
mesa-vdpau-drivers \
mpack \
mpeg3-utils \
musepack-tools \
mythes-ru \
mythes-en-us \
mythes-uk \
libido3-0.1-0 \
shim-signed \
smbclient \
sqlite3 \
stacer \
syslinux-utils \
testdisk \
thunderbird \
thunderbird-locale-en-us \
thunderbird-locale-ru \
thunderbird-locale-uk \
timeshift \
ttf-ubuntu-font-family \
gstreamer1.0-plugins-bad \
gufw \
hp-ppd \
hpijs-ppds \
node-normalize.css \
ocl-icd-libopencl1 \
openvpn \
p7zip-full \
p7zip-rar \
pepperflashplugin-nonfree \
perl-openssl-defaults \
fonts-ubuntu-title \
fonts-ubuntu-font-family-console \
okular


wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
apt-get update
apt-get install google-chrome-stable

apt install software-properties-common alsa-utils ubuntu-drivers-common -y
add-apt-repository ppa:graphics-drivers
add-apt-repository ppa:oibaf/graphics-drivers

#Untested
#apt-get remove --purge gnome*

#Remove gnome
apt remove nautilus gnome-power-manager gnome-screensaver gnome-termina* gnome-pane* gnome-applet* gnome-bluetooth gnome-desktop* gnome-sessio* gnome-user* gnome-shell-common compiz compiz* unity unity* hud zeitgeist zeitgeist* libzeitgeist* activity-log-manager-common gnome-control-center gnome-screenshot overlay-scrollba* && sudo apt-get install xubuntu-community-wallpapers && sudo apt-get autoremove
apt-get install network-manager network-manager-gnome network-manager-pptp network-manager-pptp-gnome xfce4-statusnotifier-plugin -y

#########User manage###
apt-get install gnome-system-tools
cat <<EOF >> /usr/share/applications/users.desktop
Categories=XFCE;GTK;Settings;DesktopSettings;X-XFCE-SettingsDialog;X-XFCE-HardwareSettings;
EOF

########################
printf "Change root password:\n"
passwd root

echo "Pomenyat installer"
