# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export EDITOR=vim

export P4CONFIG=.p4c
export P4DIFF=vimdiff


# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# don't let crtl-d close the session.
set -o ignoreeof

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

if [ -z "${LOGNAME}" ]; then
    LOGNAME=$USER
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) prompt_use_color=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
prompt_force_color=yes

if [ -n "$prompt_force_color" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	prompt_use_color=yes
    else
	prompt_use_color=
    fi
fi

COLOR_WHITE="\[\033[1;37m\]"
COLOR_LIGHTGRAY="\[\033[0;37m\]"
COLOR_GRAY="\[\033[1;30m\]"
COLOR_BLACK="\[\033[0;30m\]"
COLOR_RED="\[\033[0;31m\]"
COLOR_LIGHTRED="\[\033[1;31m\]"
COLOR_GREEN="\[\033[0;32m\]"
COLOR_LIGHTGREEN="\[\033[1;32m\]"
COLOR_BROWN="\[\033[0;33m\]"
COLOR_YELLOW="\[\033[1;33m\]"
COLOR_BLUE="\[\033[0;34m\]"
COLOR_LIGHTBLUE="\[\033[1;34m\]"
COLOR_PURPLE="\[\033[0;35m\]"
COLOR_PINK="\[\033[1;35m\]"
COLOR_CYAN="\[\033[0;36m\]"
COLOR_LIGHTCYAN="\[\033[1;36m\]"
COLOR_DEFAULT="\[\033[0m\]"

username_color()
{
   if [ ${UID} -eq 0 ]; then
      if [ "${USER}" == "${LOGNAME}" ]; then
         echo -ne "${COLOR_PURPLE}"
      else
         echo -ne "${COLOR_YELLOW}"
      fi
   else
      if [ "${USER}" == "${LOGNAME}" ]; then
         echo -ne "${COLOR_DEFAULT}"
      else
         echo -ne "${COLOR_BROWN}"
      fi
   fi
}

host_color()
{
   if [[ -n "${SSH_CLIENT}" ]] || [[ -n "${SSH2_CLIENT}" ]]; then 
       echo -ne "${COLOR_BLUE}"
   elif [ "$(who grep $(tty | awk -F/dev/ '{print $2}') | awk '{print $NF }')" == "(:0)" -o \
          "$(who grep $(tty | awk -F/dev/ '{print $2}') | awk '{print $NF }')" == "(:0.0)" -o \
          "$(who grep $(tty | awk -F/dev/ '{print $2}') | awk '{print $NF }')" == "" ]; then
       echo -ne "${COLOR_DEFAULT}"
   elif [[ ! -d '/proc/${PPID}/cmdline' ]]; then
       echo -ne "${COLOR_DEFAULT}"
   elif [[ "$(cat /proc/${PPID}/cmdline)" == "in.rlogind*" ]]; then
       echo -ne "${COLOR_BRWON}"
   elif [[ "$(cat /proc/${PPID}/cmdline)" == "in.telnetd*" ]]; then 
       echo -ne "${COLOR_YELLOW}"
   else
       echo -ne "${COLOR_PINK}"
   fi
}

git_prompt()
{
   git_cmd=$(which git)
   dir=$(git rev-parse --git-dir 2>/dev/null)
   
   if [ "$?" = 0 ]; then
      status=$($git_cmd status --porcelain 2>/dev/null)
      ref=$($git_cmd symbolic-ref HEAD 2>/dev/null || $git_cmd rev-parse --short HEAD 2>/dev/null)
      remote_branch=$($git_cmd rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)

      if [ -d "$dir/rebase-merge" ]; then
         ref=$(cat "$dir/rebase-merge/head-name")
         warn='REBASE'
      elif [ -d "$dir/rebase-apply" ]; then
         ref=$(cat "$dir/rebase-apply/head-name")
         warn='REBASE'
      elif [ -f "$dir/MERGE_HEAD" ]; then
         warn='MERGE'
      elif [ -f "$dir/CHERRY_PICK_HEAD" ]; then
         warn='CHERRY-PICK'
      elif [ -f "$dir/REVERT_HEAD" ]; then
         warn='REVERT'
      elif [ -f "$dir/BISECT_LOG" ]; then
         warn='BISECT'
      fi

      branch=${ref#refs/heads/}

      if [ -z "$status" ]; then
         if [[ -z "${remote_branch}" ]]; then
            #not tracking remote
            git_color=${COLOR_BLUE}
         elif [ "$($git_cmd rev-parse $branch 2>/dev/null)" != \
		"$($git_cmd rev-parse $remote_branch 2>/dev/null)" ]; then
            #differs from remote
            git_color=${COLOR_PINK}
         else
            git_color=${COLOR_GREEN}
         fi
      else
         git_color=${COLOR_RED}
      fi
   fi

   branch=${branch/X/}
   branch=${branch/feature/f}

   if [ -n "$warn" ]; then
      msg="$branch|$warn"
   else
      msg=$branch
   fi

   if [ -n "$git_color" ]; then              # if in git repository
      echo -ne "$git_color[${COLOR_DEFAULT}" # git status '['
      echo -ne "${msg}"                      # current git branch/msg
      echo -ne "$git_color]${COLOR_DEFAULT}" # git status ']'
   fi
}

color_prompt()
{
   echo -ne "$1[${COLOR_DEFAULT}"            # status color '['
   echo -ne "\!"                             # history num
   echo -ne "$1][${COLOR_DEFAULT}"           # status color ']['
   echo -ne "\$(date +%H:%M:%S)"             # time
   echo -ne "$1]["                           # status color ']['
   username_color                            # set color for username
   echo -ne "\u"                             # username
   echo -ne "$1@"                            # status color '@'
   host_color                                # set color for host
   echo -ne "\h"                             # host
   echo -ne "$1:${COLOR_DEFAULT}"            # status color ':'
   echo -ne "\w"                             # workspace
   echo -ne "$1]"                            # status color ']'
   git_prompt
   echo -ne "$1\$"                           # status color '$' or '#'
   echo -e "${COLOR_DEFAULT} "               # return to black
}

status_prompt()
{
   if [ $? = 0 ]; then
      color_prompt ${COLOR_GREEN}
   else
      color_prompt ${COLOR_RED}
   fi
}

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|*rxvt*)
    PROMPT_COMMAND='history -a;echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    # append every line to the history file on every prompt
    PROMPT_COMMAND='history -a'
    ;;
esac

if [ "$prompt_use_color" = yes ]; then
    PROMPT_COMMAND="PS1=\$(status_prompt);$PROMPT_COMMAND"
else
    PS1="[\!][\$(date +%H:%M:%S)][\u@\h:\w]\$ "
fi
unset prompt_use_color prompt_force_color

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ] && [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

alias vi='vim'
alias j='rvm use jruby-1.7.11@`grep ruby-gemset .versions.conf | sed "s/^.*=//"`'
alias mri='rvm use `grep ruby= .versions.conf | sed "s/^.*=//"`@`grep ruby-gemset .versions.conf | sed "s/^.*=//"`'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -d ${HOME}/.bash_completion ]; then
 for file in ${HOME}/.bash_completion/* ; do
   source $file
 done
fi

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
. /opt/local/etc/profile.d/bash_completion.sh
fi

if which brew 2>&1 >/dev/null; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
  fi
fi

stty stop undef

try_tmux()
{
   if which tmux 2>&1 >/dev/null; then
      tmux attach 2>/dev/null || ~/bin/tmux_hosts/tmux_$(hostname) 2>/dev/null
   fi
}

# TMUX
if [ -z "$TMUX" ]; then
   if [[ "$TERM" == rxvt-unicode* ]]; then
      try_tmux
   elif which urxvt 2>&1 >/dev/null; then
      urxvt
   else
      read -p 'Could not find urxvt, still want tmux? (y/n)' answer
      case $answer in
         [Yy]*) try_tmux
      esac
   fi
fi
