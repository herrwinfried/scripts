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
if [ -d "$wslfinder" ]; then
if [ "$distroselect" == "Fedora release 34 (Thirty Four)" ]; then
echo "$white"
echo "$magenta Kullanıcı Adınız?"
read usernamee
echo "$white $fontreset"
##########################################################################
sudo useradd -G whell $usernamee
echo "$green Lütfen Parola Oluşturunuz:"
echo "$red İşlem Sırasında Görünmeyebilir Parolanınız güvenlik gerekçesiyle. $white"
passwd $usernamee
echo "$blue Username: $usernamee"
#fi 
elif [ "$distroselect" == "Fedora release 35 (Thirty Five)" ]; then
echo "$white"
echo "$magenta Kullanıcı Adınız?"
read usernamee
echo "$white $fontreset"
##########################################################################
sudo useradd -G whell $usernamee
echo "$green Lütfen Parola Oluşturunuz:"
echo "$red İşlem Sırasında Görünmeyebilir Parolanınız güvenlik gerekçesiyle. $white"
passwd $usernamee
echo "$blue Username: $usernamee"
#fi elif [ "$distroselect" == "Fedora release 35 (Thirty Five)" ]; then
elif [ "$distroselect" == "Arch Linux" ]; then
echo "$white"
echo "$magenta Kullanıcı Adınız?"
read usernamee
echo "$white $fontreset"
echo "$blue Bash?"
echo "$white /bin/bash"
echo "$white $fontreset"
##########################################################################
useradd -mg users -G storage,wheel,power -s /bin/bash $usernamee
echo "$green Lütfen Parola Oluşturunuz:"
echo "$red İşlem Sırasında Görünmeyebilir Parolanınız güvenlik gerekçesiyle. $white"
passwd $usernamee
echo "$blue Username: $usernamee"
else
echo "$red Üzgünüm Bu Script Senin İşletim sistemin için uyarlanmadı."
fi

else
echo "$red Üzgünüm Bu Script WSL için sadece."
fi
