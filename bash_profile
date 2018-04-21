# Mostly just use this file for changing PATH

export ANDROID_HOME="$HOME/android_sdk"

path_dirs="$HOME/.rvm/bin $HOME/local/bin /opt/local/sbin /opt/local/bin /opt/local/libexec/qt5/bin /usr/local/bin \
	   /opt/apache-maven-3.5.2/bin \
           $ANDROID_HOME/tools $ANDROID_HOME/platform-tools \
           $( find $HOME/*bin -path $HOME/*bin/example -prune -o -type d | sed '/\/\./d' | tr '\n' ' ' )"

for new_dir in $path_dirs
do
  # set PATH so it includes /opt/local/bin if it exists and is not already in the path
  pattern="(^|:)$new_dir(:|$)"
  if [ -d $new_dir ] && ! echo "$PATH" | egrep -q "$pattern"; then
    new_path="$new_dir:$new_path"
  fi
done

export PATH="$new_path$PATH"

if [ -f ~/.bashrc ] && [[ $- == *i* ]]; then
  . ~/.bashrc
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

versions_conf=$(pwd)/.versions.conf
if [[ -e $versions_conf ]]; then
  rvm use `grep ruby= $versions_conf | sed "s/^.*=//"`@`grep ruby-gemset $versions_conf | sed "s/^.*=//"` > /dev/null 2>&1
fi
unset version_conf
