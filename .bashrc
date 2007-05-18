[ -f ~/.bashenv ] && source ~/.bashenv

if [ "$EUID" = "0" ] || [ $USER = "root" ]
then
	export PS1="\[\e[31m\]\A \u@\h("`uname -m`")\[\e[36m\]\w\$ \[\e[0m\]"
	export PATH=$PATH:/usr/kde/3.5/bin:/home/james/bin
	umask 022
else
	export PS1="\[\e[31m\]\A \[\e[32m\]\u@\h("`uname -m`")\[\e[36m\]\w\$ \[\e[0m\]"
	umask 022
fi

if [[ $- != *i* ]]; then
	# Shell is non-interactive.  Be done now
	return
fi
#Interactive shell stuff
# colors for ls, etc.  Prefer ~/.dir_colors #64489
if [[ -f ~/.dir_colors ]]; then
	eval `dircolors -b ~/.dir_colors`
elif [ -f /etc/DIR_COLORS ]; then
	eval `dircolors -b /etc/DIR_COLORS`
fi

# Change the window title of X terminals 
case $TERM in
	rxvt-unicode)
		alias ssh='TERM=rxvt ssh'
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}("`uname -m`"):${PWD/$HOME/~}\007"'
		;;
	xterm*|rxvt|Eterm|eterm)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}("`uname -m`"):${PWD/$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}("`uname -m`":${PWD/$HOME/~}\033\\"'
		;;
esac


# (This is no longer needed from version 0.8 of the theme engine)
# export GTK2_RC_FILES=$HOME/.gtkrc-2.0
# uncomment the following to activate bash-completion:
[ -f /etc/profile.d/bash-completion ] && source /etc/profile.d/bash-completion
[ -f /etc/bash_completion ] && source /etc/bash_completion
alias grep='grep --color=auto'
alias .='ls --color=auto'
alias ..='cd ..'
alias l='ls -l --color=auto'
#alias la='ls -la --color=auto'
#function l() { ls -ld --color=auto `find $@ -maxdepth 1 -regex ".*/[^\./][^/]*"`; }
function la() {  find "$@" -maxdepth 1 -print0 | xargs -0 ls -ld --color=auto; }
alias ls='ls --color=auto'
alias lsa='ls -a --color=auto'
function d() {   find "$@" -maxdepth 1 -print0 -xtype d -regex ".*[^\./][^/]*" | xargs -0 ls -ld --color=auto; }
function ds() {  find "$@" -maxdepth 1 -print0 -xtype d -regex ".*[^\./][^/]*" | xargs -0 ls -l --color=auto; }
function da() {  find "$@" -maxdepth 1 -print0 -xtype d  | xargs -0 ls -ld --color=auto; }
function dsa() { find "$@" -maxdepth 1 -print0 -xtype d  | xargs -0 ls -d --color=auto; }
function quiet() { $@ &>/dev/null & disown; }
alias eix='eix -c'
alias eparse="grep ebuild | sed -e 's#\[#(#g' -e 's#\]#)#g' | sed -e 's#\([^)]*) \)\([^\t ]*\)\(.*\)#=\2#g'"
alias find-in-code='find-in-files ".*\.\(h\|hxx\|cpp\|cc\|C\|cxx\|c\|S\|s\)"'
alias sed-in-code='sed-in-files ".*\.\(h\|hxx\|cpp\|cc\|C\|cxx\|c\|S\|s\)"'
alias bashrc-update='source ~/.bashrc'
alias profile-update='source /etc/profile'
alias open='kfmclientexec'
[ -x `which colordiff 2>/dev/null` ] && alias diff=colordiff
alias df='df -T'
[ -x `which ipython 2>/dev/null` ] && alias python=ipython
alias make-kernel='sudo make all modules_install install'
alias ripdvd='dvd9to5.pl -D'
alias hex='od -Ax -tx1z -v'
alias internet-usage='ssh server sudo internet-usage'
alias cosctunnel='ssh cosctunnel ./tunnel/server'
function launch() { "$@" &>/dev/null &disown ; }
function title() { echo -ne "\033]0;${1}\007"; }
function oxine() { \oxine -L -J -F "$@" &>/dev/null ; }


export EDITOR=vim

#Very handy for when you need to use for loops etc, but causes bash-completion to go wonky, so would suggest turn on and off when needed
#IFS=$'\n'
unset IFS

echo -e "Logging in to $(tty)...\nWelcome to $(hostname), $(whoami).\nThe time is now $(date +%H:%M:%S), on $(date +%A), $(date +%d\ %B\,\ %G)."
cd
