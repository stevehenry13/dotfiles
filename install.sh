#!/bin/bash

for file in $(ls $(dirname $0) | grep -v *.pub | grep -v $(basename $0)); do
  if [ -f ~/.$file ]; then
    mv ~/.$file{,.bak}
  fi

  ln -s $file ~/.$file
done

# ssh pub keys should be add to authorized_keys, so that passwordless ssh works
mkdir -p .ssh
cat $(dirname $0)/*.pub >> .ssh/authorized_keys
