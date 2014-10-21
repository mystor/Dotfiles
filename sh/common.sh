#######
# Common Shell Configuration
# Must be valid on both bash and zsh
#######

# Vim like keybindings in the shell
set -o vi

# set EDITOR
export EDITOR=vim

# Make vim work better
alias vim='TERM=screen-256color vim'
alias v='TERM=screen-256color vim'

# A whole ton of emacs aliases to make emacs not suck
alias temacs='emacsclient -nw -s "term" -a ""'
alias gemacs='emacsclient -c -n -s "gui" -a ""'
alias kill-temacs='emacsclient -s "term" -e "(kill-emacs)"'
alias kill-gemacs='emacsclient -s "gui" -e "(kill-emacs)"'

# And a bunch more, so that we can be more terse
alias emacs='temacs'
alias tec='temacs'
alias gec='gemacs'
alias ec='emacs'

# Enable virtualenvwrapper
VIRTUAL_ENV="/usr/local/bin/virtualenvwrapper.sh"
if [ -f "$VIRTUAL_ENV" ]; then
	export WORKON_HOME="$HOME/.virtualenvs"
	mkdir -p "$WORKON_HOME"
	source "$VIRTUAL_ENV"
fi
