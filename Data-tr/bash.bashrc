# Command history tweaks:
# - Append history instead of overwriting
#   when shell exits.
# - When using history substitution, do not
#   exec command immediately.
# - Do not save to history commands starting
#   with space.
# - Do not save duplicated commands.
shopt -s histappend
shopt -s histverify
export HISTCONTROL=ignoreboth

# Default command line prompt.
PROMPT_DIRTRIM=2
PS1='\[\e[31m\]╭—(\[\e[32m\]$(whoami)@$(hostname)\[\e[31m\])-[\[\e[0m\]\w\[\e[31m\]]\n\[\e[0;31m\]╰——\[\e[0;32m\]\$\[\e[32m\] '

# Handles nonexistent commands.
# If user has entered command which invokes non-available
# utility, command-not-found will give a package suggestions.
if [ -x /data/data/com.termux/files/usr/libexec/termux/command-not-found ]; then
	command_not_found_handle() {
		/data/data/com.termux/files/usr/libexec/termux/command-not-found "$1"
	}
fi

# show logo
if [ -f $PREFIX/etc/logo-tengkorak.ascii ];then clear
  glogo="$(cat $PREFIX/etc/logo-tengkorak.ascii)"
  echo -e "\e[0;32m $glogo"
fi

# login termux-red
if [ -f $PREFIX/bin/termux-red ];then termux-red; fi

#@stalkersx
