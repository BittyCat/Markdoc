#!/bin/bash

echo "conf [sysdir] -- configure all"

conf(){
  sudo echo -n
  while IFS= read -r line;do
    line="${line/\~/~}"
    sudo mkdir -p "${line%/*}"
    sudo rsync -aHog "$1/sync/${line##*/}" "${line}"
    echo "-> ${line}"
  done < "$1/conf/sync.conf"

  echo "## dconf load / < gnome.conf"
  dconf load / < "$1/conf/gnome.conf" 2>/dev/null

  echo ">> ~/.bashrc"
  if ! grep '# Bash Run Commands' ~/.bashrc >/dev/null;then
    echo $'\n'"# Bash Run Commands" >> ~/.bashrc
    echo "## Bash Scripts" >> ~/.bashrc
    find "$1/bash/" -type f -name '*.bash' \
      -printf '. "%p" >/dev/null\n' >> ~/.bashrc
    echo $'\n'"## SSHFS" >> ~/.bashrc
    echo ". \"$1/conf/sshfs.conf\"" >> ~/.bashrc
    cat "$1/conf/bashrc.conf" >> ~/.bashrc
  fi

  while IFS= read -r line;do
    line="${line/\~/~}"
    rsync -aHog "${line}" "$1/save/"
    echo "<- ${line}"
  done < "$1/conf/save.conf"
}

echo "upd8 [sysdir] -- update system"

upd8(){
  sudo apt --assume-yes update
  xargs -a "$1/conf/pkg.conf" sudo apt install
  sudo apt --assume-yes upgrade
  sudo apt --assume-yes autoremove
}

echo "gems [sysdir] -- install gems"

gems(){
  xargs -a "$1/conf/gems.conf" sudo gem install
}
