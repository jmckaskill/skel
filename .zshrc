# Created by newuser for 4.3.4
source ~/.zshprompt
bindkey -e .safe
alias l='ls -l --color'
alias ls='ls --color'
alias ..='cd ..'
alias mview='mplayer -ao null'
alias heron='rdesktop -u james -g 950x1170 -x -l -K heron'
alias heron-fs='rdesktop -u james -g 1915x1170 -x -l -K heron'
alias heron-a='rdesktop -u james -g 1275x994 -x -l -K heron'
alias str='sudo hibernate-ram'
alias df='df -T'
imdb() { elinks "http://www.imdb.com/find?s=all&q=$1"; }

export EDITOR=vim
export PATH=/opt/bin:~/bin:$PATH
export PAGER=most
export GREP_OPTIONS="--color=auto"
export GREP_COLOR="1;32"
