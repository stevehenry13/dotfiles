#!/bin/bash

file_list=$(ls $(dirname $0) | grep -v -e "subversion" -e "rvm" -e "$(basename $0)")

# only link the files under the directory, not the whole directory (like chef and vim)
file_list="$file_list subversion/config"
file_list="$file_list rvm/gemsets/global.gems"

for file in $file_list; do
  if [ -h ~/.$file ]; then
    rm ~/.$file
  elif [ -e ~/.$file ]; then
    if cmp --silent ~/.$file $(pwd)/$(dirname $0)/$file; then
      rm ~/.$file
    else
      mv ~/.$file{,.bak}
    fi
  fi

  # Ensure the parent dir exists
  mkdir -p $(dirname ~/.$file)
  ln -s $(pwd)/$(dirname $0)/$file ~/.$file
done

if [ -h ~/.Xresources ]; then
  rm ~/.Xresources
fi

# symlink for X config
ln -s ~/.Xdefaults ~/.Xresources

# Fetch vundle
mkdir -p vim/bundle
if [[ ! -d 'vim/bundle/Vundle.vim' ]]; then
  git clone https://github.com/gmarik/Vundle.vim.git vim/bundle/Vundle.vim
fi

# Install vim plugins
vim +PluginInstall +qall

if $(hash npm 2>/dev/null); then
  pushd vim/bundle/tern_for_vim >/dev/null
  npm install
  popd >/dev/null
else
  echo 'NPM is not installed'
fi
