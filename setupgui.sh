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
  echo "$red İşlem İptal: lsb_release Paketi Bulunmadığından işlem iptal edildi." >&2
  #echo "$cyan lsb-release | redhat-lsb-core package required."
  exit 1
fi

if ! [ -x "$(command -v screenfetch)" ]; then
  echo "$red İşlem İptal: screenfetch Paketi Bulunmadığından işlem iptal edildi." >&2
  #echo "$cyan screenfetch package required."
  exit 1
fi
########################FINISH#####################################
####OS SELECT
export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')
#########FINISH###################
if [[ ! "$(screenfetch)" =~ "on the Windows Subsystem for Linux" ]]; then
echo "$red Üzgünüm Bu Script WSL için sadece."
exit 1
fi
dnfvalue=$1
if [ "$distroselect" == "openSUSE Tumbleweed" ]; then
if [ "$dnfvalue" == "--no-dnf" ]; then
echo "$blue --no-dnf parametresinden dolayı zypper tercih ediliyor."
  sudo zypper --gpg-auto-import-keys in -y noto-sans-fonts gsettings-desktop-schemas xorg-x11-libs xorg-x11-server humanity-icon-theme patterns-fonts-fonts patterns-fonts-fonts_opt xorg-x11-fonts materia-gtk-theme
else 
##########
if ! [ -x "$(command -v dnf)" ]; then
  echo "$red DNF Yüklü Olmadığından Zypper İle yüklenecek. $white" >&2
  sudo zypper --gpg-auto-import-keys in -y noto-sans-fonts gsettings-desktop-schemas xorg-x11-libs xorg-x11-server humanity-icon-theme patterns-fonts-fonts patterns-fonts-fonts_opt xorg-x11-fonts materia-gtk-theme
else
echo "$blue DNF ile Yüklenecek $white"
  sudo dnf install -y noto-sans-fonts gsettings-desktop-schemas xorg-x11-libs xorg-x11-server humanity-icon-theme patterns-fonts-fonts patterns-fonts-fonts_opt xorg-x11-fonts materia-gtk-theme
fi
fi
###################################################################
elif [ "$distroselect" == "openSUSE Leap 15.3" ]; then
if [ "$dnfvalue" == "--no-dnf" ]; then
echo "$blue --no-dnf parametresinden dolayı zypper tercih ediliyor."
  sudo zypper --gpg-auto-import-keys in -y noto-sans-fonts gsettings-desktop-schemas xorg-x11-libs xorg-x11-server humanity-icon-theme patterns-fonts-fonts patterns-fonts-fonts_opt xorg-x11-fonts materia-gtk-theme
else 
##########
if ! [ -x "$(command -v dnf)" ]; then
  echo "$red DNF Yüklü Olmadığından Zypper İle yüklenecek. $white" >&2
  sudo zypper --gpg-auto-import-keys in -y noto-sans-fonts gsettings-desktop-schemas xorg-x11-libs xorg-x11-server humanity-icon-theme patterns-fonts-fonts patterns-fonts-fonts_opt xorg-x11-fonts materia-gtk-theme
else
echo "$blue DNF ile Yüklenecek $white"
  sudo dnf install -y noto-sans-fonts gsettings-desktop-schemas xorg-x11-libs xorg-x11-server humanity-icon-theme patterns-fonts-fonts patterns-fonts-fonts_opt xorg-x11-fonts materia-gtk-theme
fi
fi
###################################################################
else
echo "$red Üzgünüm Bu Script Senin İşletim sistemin için uyarlanmadı."
fi
########

echo "$blue Script Bitti."
