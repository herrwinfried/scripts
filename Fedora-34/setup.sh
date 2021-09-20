#!/bin/bash

### Fonts
termcols=$(tput cols)
bold="$(tput bold)"
fontnormal="$(tput init)"
fontreset="$(tput reset)"
underline="$(tput smul)"
standout="$(tput smso)"
normal="$(tput sgr0)"
black="$(tput setaf 0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
blue="$(tput setaf 4)"
magenta="$(tput setaf 5)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"
### Finish

if [[ $EUID -ne 0 ]]; then
   echo "$red TUR:Süper Kullanıcı/Root Olmanız gerekiyor." 
     #echo "$red ENG:You need to be Super User/Root." 
       #echo "$red GER: Sie müssen Superuser/Root sein." 
   exit 1
fi
echo "$yellow redhat-lsb-core ve screenfetch paketleri gereklidir."
#################
#####lsb-core required##############################################
if ! [ -x "$(command -v lsb_release)" ]; then
    echo "$yellow Dikkat ! redhat-lsb-core Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo dnf install --skip-broken -y redhat-lsb-core
fi

if ! [ -x "$(command -v screenfetch)" ]; then
  echo "$yellow Dikkat ! screenfetch Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo dnf install --skip-broken -y screenfetch
fi


########################FINISH#####################################
####OS SELECT
export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')
#########FINISH###################
if [ "$distroselect" == "Fedora release 34 (Thirty Four)" ]; then
###Only OpenSUSE TW
echo snap_act=$1
echo "$white $fontreset"

echo "$green Kullanıcı Adınız ?"
read usernamee
echo "$white $fontreset"
########################
echo "$blue Kullanıcı Klasörünüz Adresini Giriniz? $green (home dizindeki klasörünüz adınız) $cyan (Örneğin: Winfried)"
read homefolder
echo "$white $fontreset"

echo "Klasörünüz Tanımlı Olduğu Yer?"
echo "$white /home/$homefolder/Fedora-34"
setupfolder=/home/$homefolder/Fedora-34
echo "$white $fontreset"

echo "$red Kullanıcı Adınız: $usernamee"
echo "$blue Kullanıcı Klasörünüz: /home/$homefolder "
echo "$green Kurulum Klasörün Tanımlı Olduğu Yer: /home/$homefolder/Fedora-34"
echo "$yellow Doğru Olduğunu Kabul Ediyorsanız enter tuşuna basın. Doğru Olduğunu Düşünmüyor iseniz $red CTRL+C $yellow tuşlarına birkaç kere basarak sonlandırın."
read okeys

echo "$white $fontreset"
#####################################################
function update {
   sudo dnf update --refresh -y
}

function nvidia {
	sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm fedora-workstation-repositories

dnf install -y kernel-devel kernel-headers gcc make dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig
	sudo dnf install -y --skip-broken xorg-x11-drv-nvidia-libs.x86_64 xorg-x11-drv-nvidia-cuda.x86_64 xorg-x11-drv-nvidi-devel.x86_64 xorg-x11-drv-nvidia-kmodsrc.x86_64 kmod-nvidia.x86_64 xorg-x11-drv-nvidia.x86_64 mesa-libglapi freeglut-devel xorg-x11-drv-nvidia-libs.i686 xorg-x11-drv-nvidia-cuda.i686 xorg-x11-drv-nvidia-devel.i686
	
}
function repository {
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm fedora-workstation-repositories
###############################################################################
	sudo dnf install -y dnf-plugins-core
	sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
	sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
	###############################################################################
sudo dnf copr enable -y taw/element
	###############################################################################
	sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
	sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
	###############################################################################
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
    ###############################################################################
    sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
    printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg" |sudo tee -a /etc/yum.repos.d/vscodium.repo
	###############################################################################
	sudo dnf update -y
}
function basepackage {
	sudo dnf install -y --skip-broken powerline-fonts neofetch onboard hwinfo htop ffmpeg redshift zsh git curl wget redhat-lsb-core zsh-autosuggestions zsh-syntax-highlighting
	
	sudo dnf install -y --skip-broken telegram-desktop discord brave-browser pinta openshot flameshot element
	sudo dnf group install -y --skip-broken --with-optional "libreoffice" "Yazdırma Desteği"
	#sudo dnf group install -y --with-optional --skip-broken "office"
}
function printers {
sudo dnf install -y skanlite cups cups-client cups-filters system-config-printer
	sudo dnf install -y skanlite system-config-printer
	sudo dnf install -y hplip
	#sudo adduser $home lpadmin
	sudo service cups start
	sudo systemctl start cups
	sudo systemctl enable cups
}

function flatpak_snap {
function flatpaksetup {
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}
function snapsetup {
sudo ln -s /var/lib/snapd/snap /snap
}
if [ "$snap_act" == "--snap" ]; then
sudo dnf install -y --skip-broken flatpak snapd
flatpaksetup
snapsetup
else
sudo dnf install -y --skip-broken flatpak
flatpaksetup
fi
}

function web_dev {
	sudo dnf group install -y --with-optional --skip-broken "Temel Web Sunucusu" "PHP" "MongoDB" "MariaDB (MySQL) Veri Tabanı"
	curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo dnf install -y --skip-broken composer nodejs filezilla
}
function desktop_dev {
	sudo dnf install -y --skip-broken swift-lang dotnet-sdk-5.0
	sudo dnf group install -y --with-optional --skip-broken "Python Sınıfı" "PostgreSQL Veri Tabanı" "RPM Geliştirme Araçları" "C Geliştirme Araçları ve Kütüphaneleri" "Geliştirme Araçları"
	sudo dnf group install --with-optional --skip-broken "java-development" "java"
}
function ide_text {
	sudo dnf install -y sublime-text codium code
}
function game_video {
	sudo dnf install -y --skip-broken lutris minetest obs-studio kdenlive
	sudo dnf install -y --skip-broken steam --enablerepo=rpmfusion-nonfree-steam
}
function rpms {
	cd /home/$home_dir/$dir_dir/rpms
	sudo dnf install -y ./*.rpm
	sudo dnf update 
}
function runs {
	cd /home/$home_dir/$dir_dir/runs
	find . -iname '*.run' -exec chmod +x ./"{}" \;
	find . -iname '*.run' -exec sudo ./"{}" \;
}
function bundles {
	cd /home/$home_dir/$dir_dir/bundles
	find . -iname "*.bundle" -exec chmod +x ./"{}" \;
	find . -iname "*.bundle" -exec sudo ./"{}" \;
	
}
function appimages {
	cd /home/$home_dir/$dir_dir/appimages
	find . -iname "*.appimage" -exec chmod +x ./"{}" \;
	find . -iname "*.appimage" -exec sudo ./"{}" \;
}
update
repository
nvidia
basepackage
printers
flatpak_snap
game_video
ide_text
web_dev
desktop_dev
rpms
bundles
runs
#appimages

#finish
else
### ! opensuse TW 
echo "$red Üzgünüm İşletim Sistemini Bu Script Desteklemiyor."
exit 1
fi