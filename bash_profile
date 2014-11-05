if [ -f ~/.profile ]; then
  . ~/.profile
fi

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export PATH=/usr/local/bin:$PATH

##
# Your previous /Users/henrys4/.bash_profile file was backed up as /Users/henrys4/.bash_profile.macports-saved_2014-11-04_at_10:51:34
##

# MacPorts Installer addition on 2014-11-04_at_10:51:34: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

