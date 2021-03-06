# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples


export EDITOR=vim

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

HISTTIMEFORMAT="%Y%m%d %H:%M:%S "

# append to the history file, don't overwrite it
shopt -s histappend

HISTSIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

symbolic_hostname="`cat /etc/symbolic_hostname 2> /dev/null`.d"
if [ "$symbolic_hostname" == ".d" ]; then
    symbolic_hostname=`hostname`
fi

# Check for the variable "env_type" in /etc/environment
# This is used to determine the colour of the PS1.
# Possible values: local, unstable, testing, stable or unknown
# Update this in each machine we ssh to.
if [ -f /etc/environment ]; then
    source /etc/environment
else
    env_type="unknown"
fi

if [ "$color_prompt" = yes ]; then

    # Blue for own comp
    if [[ "$HOSTNAME" = *"local"* ]] || [[ "$env_type" = "local" ]]; then
        color="4"

    # Green for dev
    elif [[ "$HOSTNAME" = *"dev."* ]] || [[ "$env_type" = "unstable" ]]; then
        color="2"

    # Yellow for testing
    elif [[ "$HOSTNAME" = *"testing."* ]] || [[ "$env_type" = "testing" ]]; then
        color="3"

    # Red for production
    elif [[ "$env_type" = *"stable"* ]]; then
        color="1"

    # Red for unknown
    else
        color="1"
    fi

    # Post on how PS1 works in general.
    # http://blog.superuser.com/2011/09/21/customizing-your-bash-command-prompt/
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\u@$symbolic_hostname\[\033[00m\]:$(__git_ps1 "\[\033[01;35m\]%s\[\033[00m\]@")\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@$symbolic_hostname:\w$(__git_ps1 "(%s)")\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]1"
#    ;;
#*)
#    ;;
#esac


# If this is an xterm set the title to user@host:dir
 case "$TERM" in
 xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
     ;;
 *)
     ;;
 esac

# http://unix.stackexchange.com/a/152139
###
# Configure PS1 by using the old value but ensuring it starts on a new line.
###
__configure_prompt() {
  PS1=""

  if [ "$(__get_terminal_column)" != 0 ]; then
    PS1="\n"
  fi

  PS1+="$PS1_WITHOUT_PREPENDED_NEWLINE"
}

###
# Get the current terminal column value.
#
# From http://stackoverflow.com/a/2575525/549363.
###
__get_terminal_column() {
  exec < /dev/tty
  local oldstty=$(stty -g)
  stty raw -echo min 0
  echo -en "\033[6n" > /dev/tty
  local pos
  IFS=';' read -r -d R -a pos
  stty $oldstty
  echo "$((${pos[1]} - 1))"
}

# Save the current PS1 for later.
PS1_WITHOUT_PREPENDED_NEWLINE="$PS1"

# Use our prompt configuration function, preserving whatever existing
# PROMPT_COMMAND might be configured.
PROMPT_COMMAND="__configure_prompt;$PROMPT_COMMAND"

# end http://unix.stackexchange.com/a/152139


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

# enable color support (linux) of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
fi

# Enable color coding support for OS X
export CLICOLOR=1
# LSCOLORS needs to be tweaked
export LSCOLORS=ExFxCxDxBxegedabagacad

# some more ls aliases
alias mongis='cowsay -f kitty "grattz";sleep 10'
#alias la='ls -A'
#alias l='ls -CF'
alias rm='rm -i'
alias ssh='ssh -A'
alias cp='cp -i'
alias mv='mv -i'
alias l='ls -la -G'
alias sl='cowsay "slow down boi!";sleep 10'
alias py='python '
alias cdiff='bash ~/src/misc/coloured_svn_diff.sh'
alias gst='git status'
alias gd='git diff'
alias gdc='git diff --cached'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias grep='grep --color=auto'
alias grepc='grep -r --exclude-dir=*i18n*'
alias amend='git commit --amend -C HEAD'
alias amenda='git commit -a --amend -C HEAD'
alias gsuir='git submodule update --init --recursive'

# Find only files relevant to the current git repo, ignoring i18n folders (!)
alias grepc='git ls-files --recurse-submodules | grep -v "i18n" | xargs grep -s --color=auto'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# git autocomplete
if [ -f /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash ]; then
  .  /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
  .  /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh
elif [ -f ~/.git-completion.bash ]; then
  .  ~/.git-completion.bash
fi

# enable the same thing on OS X, when installed through homebrew.
#if [ -f `brew --prefix`/etc/bash_completion ]; then
	#. `brew --prefix`/etc/bash_completion
#fi

# Make sure shell knows where to find Node.js modules i added:
export NODE_PATH="/usr/local/lib/node"
# As some modules have executables also add:
export PATH="/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/share/npm/bin:/usr/local/share/npm/lib:$PATH:/home/datacarl/bin"

# postgres
export PGHOST="localhost"

# avoid bash crying about unknown locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export AWS_CREDENTIAL_FILE=/Users/datacarl/.credentials/aws.txt

function createCSRwpw {
  openssl genrsa -des3 -out server.key 2048
  openssl req -new -key server.key -out server.csr
}

function createCSRwopw {
  openssl genrsa -out server.key 2048
  openssl req -new -key server.key -out server.csr
}

function signCSR {
  openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
}

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

#VSCode
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
