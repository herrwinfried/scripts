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
echo "$yellow lsb-release ve screenfetch paketleri gereklidir."
#################
#####lsb-core required##############################################
if ! [ -x "$(command -v lsb_release)" ]; then
    echo "$yellow Dikkat ! lsb-release Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo zypper --gpg-auto-import-keys in -y lsb-release
fi

if ! [ -x "$(command -v screenfetch)" ]; then
  echo "$yellow Dikkat ! screenfetch Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo zypper --gpg-auto-import-keys in -y screenfetch
fi


########################FINISH#####################################
####OS SELECT
export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')
#########FINISH###################
if [ "$distroselect" == "openSUSE Tumbleweed" ]; then
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
echo "$white /home/$homefolder/Tumbleweed"
setupfolder=/home/$homefolder/Tumbleweed
echo "$white $fontreset"

echo "$red Kullanıcı Adınız: $usernamee"
echo "$blue Kullanıcı Klasörünüz: /home/$homefolder "
echo "$green Kurulum Klasörün Tanımlı Olduğu Yer: /home/$homefolder/Tumbleweed"
echo "$yellow Doğru Olduğunu Kabul Ediyorsanız enter tuşuna basın. Doğru Olduğunu Düşünmüyor iseniz $red CTRL+C $yellow tuşlarına birkaç kere basarak sonlandırın."
read okeys

echo "$white $fontreset"
#####################################################
function update {
   sudo zypper --gpg-auto-import-keys dup -y
}
function zramadd {

sudo zypper install -y systemd-zram-service
sudo zramswapon
sudo systemctl enable zramswap

}
function nvidiaG05 {
    sudo zypper --gpg-auto-import-keys addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
    zypper --gpg-auto-import-keys install -y nvidia-glG05 x11-video-nvidiaG05
}
function nvidiaG04 {
    sudo zypper --gpg-auto-import-keys addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
    zypper --gpg-auto-import-keys install -y nvidia-glG04 x11-video-nvidiaG04
}
function repository {
sudo zypper --gpg-auto-import-keys addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' packman
sudo zypper refresh
sudo zypper dist-upgrade --from packman --allow-vendor-change
sudo zypper install --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs
######################################################
sudo zypper --gpg-auto-import-keys addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
######################################################
sudo zypper install -y curl
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo zypper --gpg-auto-import-keys addrepo https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
######################################################
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo zypper --gpg-auto-import-keys addrepo -g -f https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
######################################################
sudo zypper --gpg-auto-import-keys addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
#####################################################
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
######################################################
sudo rpmkeys --import -y https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
sudo sh -c 'echo -e "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg" > /etc/zypp/repos.d/vscodium.repo'
######################################################
sudo zypper install -y libicu
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
wget https://packages.microsoft.com/config/opensuse/15/prod.repo
sudo mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
sudo chown root:root /etc/zypp/repos.d/microsoft-prod.repo
######################################################
sudo zypper --gpg-auto-import-keys refresh
}

function dnfsetup {
 sudo zypper --gpg-auto-import-keys install -y dnf rpm-repos-openSUSE
   sudo dnf swap -y PackageKit-backend-zypp PackageKit-backend-dnf
   sudo dnf makecache -y && sudo zypper --gpg-auto-import-keys refresh

}

function basepackage {
sudo dnf install -y --skip-broken fetchmsttfonts powerline-fonts
sudo dnf install -y --skip-broken neofetch screenfetch onboard hwinfo htop ffmpeg redshift zsh git curl wget lsb-release
sudo dnf install -y --skip-broken telegram-desktop discord brave-browser pinta openshot flameshot gimp
#	sudo dnf install -y patterns-server-printing
}
function flatpak_snap {
function flatpaksetup {
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}
function snapsetup {
sudo ln -s /var/lib/snapd/snap /snap
sudo systemctl enable snapd && sudo systemctl start snapd
sudo systemctl enable snapd.apparmor && sudo systemctl start snapd.apparmor
}
if [ "$snap_act" == "--snap" ]; then

sudo dnf makecache -y
sudo dnf install -y --skip-broken flatpak snapd
flatpaksetup
snapsetup
else
sudo dnf makecache -y
sudo dnf install -y --skip-broken flatpak
flatpaksetup
fi
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
function desktop_dev {
	sudo dnf install -y --skip-broken patterns-devel-base-devel_basis java-16-openjdk dotnet-sdk-5.0
    # sudo dnf install -y patterns-devel-mono-devel_mono patterns-devel-python-devel_python3 patterns-kde-devel_qt5 patterns-devel-base-devel_rpm_build patterns-devel-java-devel_java patterns-devel-C-C++-devel_C_C++
}

function web_dev {
    # sudo dnf install -y patterns-devel-base-devel_web composer
sudo dnf install -y --skip-broken nodejs-default filezilla icedtea-web
}

function ide_text {
	sudo dnf install -y sublime-text codium code
}
function game_video {
	sudo dnf install -y --skip-broken lutris minetest steam gamemoded obs-studio kdenlive
	#sudo flatpak install -y flathub com.obsproject.Studio
	
}

function rpms {
	cd /home/$home_dir/$dir_dir/rpms
	sudo dnf install -y ./*.rpm
	sudo dnf update --refresh -y
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
zramadd
nvidiaG05
#nvidiaG04
repos
dnf
pakete
snap_flatpak
printer
desktop_dev
web_dev
ide_text
game_video
rpms
runs
bundles
#appimages
#finish
else
### ! opensuse TW 
echo "$red Üzgünüm İşletim Sistemini Bu Script Desteklemiyor."
exit 1
fi