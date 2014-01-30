#!/bin/bash

file_list=$(ls $(dirname $0) | grep -v -e "*.pub" -e "subversion" -e "ssh" -e "rvm" -e "$(basename $0)")

# only link the svn config file, not the whole directory
file_list="$file_list subversion/config ssh/config rvm/gemsets/global.gems"

for file in $file_list; do
  if [ -h ~/.$file ]; then
    rm ~/.$file
  elif [ -e ~/.$file ]; then
    mv ~/.$file{,.bak}
  fi

  # Ensure the parent dir exists
  mkdir -p $(dirname ~/.$file)
  ln -s $(pwd)/$(dirname $0)/$file ~/.$file
done

# Fix the svn diff to look in the right home directory
sed -i "s,\(diff-cmd = \).*/\([\.a-z_]*\),\1${HOME}/\2," ~/.subversion/config

if [ -h ~/.Xresources ]; then
  rm ~/.Xresources
fi

# symlink for X config
ln -s ~/.Xdefaults ~/.Xresources

# ssh pub keys should be add to authorized_keys, so that passwordless ssh works
for file in $(ls $(dirname $0)/*.pub); do
  if [ -z "$(grep "$(cat $file)" ~/.ssh/authorized_keys 2>/dev/null)" ]; then
    mkdir -p ~/.ssh
    cat $file >> ~/.ssh/authorized_keys
    chmod 700 ~/.ssh
    chmod 640 ~/.ssh/authorized_keys
  fi
done
