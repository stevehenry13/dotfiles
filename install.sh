#!/bin/bash

file_list=$(ls $(dirname $0) | grep -v *.pub | grep -v subversion | grep -v $(basename $0))

# only link the svn config file, not the whole directory
file_list="$file_list subversion/config"

for file in $file_list; do
  if [ -h ~/.$file ]; then
    rm ~/.$file
  elif [ -e ~/.$file ]; then
    mv ~/.$file{,.bak}
  fi

  ln -s $(pwd)/$file ~/.$file
done

# ssh pub keys should be add to authorized_keys, so that passwordless ssh works
for file in $(ls $(dirname $0)/*.pub); do
  if [ -z "$(grep "$(cat $file)" ~/.ssh/authorized_keys 2>/dev/null)" ]; then
    mkdir -p ~/.ssh
    cat $file >> ~/.ssh/authorized_keys
  fi
done
