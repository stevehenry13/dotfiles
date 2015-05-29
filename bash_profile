# Mostly just use this file for changing PATH

export ANDROID_HOME="$HOME/android_sdk"

path_dirs="$HOME/.rvm/bin $HOME/local/bin /opt/local/sbin /opt/local/bin /usr/local/bin \
           $ANDROID_HOME/tools $ANDROID_HOME/platform-tools \
           $( find $HOME/bin -type d | sed '/\/\./d' | tr '\n' ' ' )"

for new_dir in $path_dirs
do
  # set PATH so it includes /opt/local/bin if it exists and is not already in the path
  if [ -d $new_dir ] && ! [[ "$PATH" =~ (^|:)$new_dir(:|$) ]]; then
    new_path="$new_dir:$new_path"
  fi
done

export PATH="$new_path$PATH"

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
