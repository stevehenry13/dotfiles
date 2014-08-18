#!/bin/bash

file_list=$(ls $(dirname $0) | grep -v -e "subversion" -e "ssh" -e "rvm" -e "$(basename $0)")

# only link the files under the directory, not the whole directory (like chef and vim)
file_list="$file_list subversion/config"
file_list="$file_list ssh/config"
file_list="$file_list rvm/gemsets/global.gems"

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
sed -i'' "s,\(diff-cmd = \).*/\([\.a-z_]*\),\1${HOME}/\2," ~/.subversion/config

if [ -h ~/.Xresources ]; then
  rm ~/.Xresources
fi

# symlink for X config
ln -s ~/.Xdefaults ~/.Xresources

# ssh pub keys should be added to authorized_keys, so that passwordless ssh works
pub_file_list=$(find $(dirname $0)/ssh -name "*.pub")
for file in $pub_file_list; do
  if [ -z "$(grep "$(cat $file)" ~/.ssh/authorized_keys 2>/dev/null)" ]; then
    mkdir -p ~/.ssh
    cat $file >> ~/.ssh/authorized_keys
    chmod 700 ~/.ssh
    chmod 640 ~/.ssh/authorized_keys
  fi
done

# Fetch vundle
mkdir -p vim/bundle
if [[ ! -d 'vim/bundle/Vundle.vim' ]]; then
  git clone https://github.com/gmarik/Vundle.vim.git vim/bundle/Vundle.vim
fi

# Install vim plugins
vim +PluginInstall +qall
