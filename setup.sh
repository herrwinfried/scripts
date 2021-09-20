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
#################
wslfinder="/mnt/wsl"
###############
#####lsb-core required##############################################
if ! [ -x "$(command -v lsb_release)" ]; then
  echo "$red İşlem İptal: lsb_release Paketi Bulunmadığından işlem iptal edildi." >&2
  #echo "$cyan lsb-release | redhat-lsb-core package required."
echo "$cyan lsb-release | redhat-lsb-core paket gerekli."
  exit 1
fi
########################FINISH#####################################
####OS SELECT
export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')
#########FINISH###################
if [ ! -d "$wslfinder" ]; then
echo "$red Üzgünüm Bu Script WSL için sadece."
exit
fi

if [ "$distroselect" == "openSUSE Tumbleweed" ]; then
function update {
sudo zypper --gpg-auto-import-keys dup -y
}
function repository {
sudo zypper --gpg-auto-import-keys addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' packman
sudo zypper --gpg-auto-import-keys refresh
sudo zypper --gpg-auto-import-keys dist-upgrade -y --from packman --allow-vendor-change
#################################
sudo zypper --gpg-auto-import-keys install -y libicu
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
wget https://packages.microsoft.com/config/opensuse/15/prod.repo
sudo mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
sudo chown root:root /etc/zypp/repos.d/microsoft-prod.repo
##########################################
sudo zypper --gpg-auto-import-keys refresh
}
function dnfsetup {
sudo zypper --gpg-auto-import-keys install -y dnf rpm-repos-openSUSE
sudo dnf swap -y PackageKit-backend-zypp PackageKit-backend-dnf
sudo zypper --gpg-auto-import-keys refresh && sudo dnf makecache -y
}
function basepackage {
sudo zypper install --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full
sudo dnf install -y zsh curl neofetch screenfetch git opi
}
function developerpackage {
    sudo dnf install -y nodejs-default python38 dotnet-sdk-5.0 llvm-clang icu
    ###Swift Language
    cd /tmp/
    wget https://swift.org/builds/swift-5.4.3-release/centos8/swift-5.4.3-RELEASE/swift-5.4.3-RELEASE-centos8.tar.gz -O Swift.tar.gz
    tar xvzf /tmp/Swift*.tar.gz -C /tmp/
    sudo mkdir /opt/swift
    sudo mv /tmp/swift* /opt/swift
    sudo chown -R root:root /opt/swift
    wget -q -O - https://swift.org/keys/all-keys.asc | sudo gpg --import -
    echo 'export PATH=/opt/swift/usr/bin:$PATH' >> ~/.bashrc
    ### Swift Language
}

update
repository
dnfsetup
basepackage
developerpackage
###################################################################
elif [ "$distroselect" == "Fedora release 34 (Thirty Four)" ]; then
function update {
sudo dnf update --refresh -y
}
function repository {
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf update -y
}
function basepackage {
sudo dnf install -y passwd cracklib-dicts iputils util-linux-user
sudo dnf install -y git curl zsh wget dnf-plugins-core dnf-utils sudo neofetch screenfetch
}
function developerpackage {
    sudo dnf install -y swift-lang dotnet-sdk-5.0 nodejs python3
}

update
repository
basepackage
developerpackage
#fi
elif [ "$distroselect" == "Arch Linux" ]; then
echo "tes"
else
echo "$red Üzgünüm Bu Script Senin İşletim sistemin için uyarlanmadı."
fi

echo "$blue Script Bitti."