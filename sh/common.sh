#######
# Common Shell Configuration
# Must be valid on both bash and zsh
#######

# Vim like keybindings in the shell
set -o vi

# Add powerline to the PATH
export PATH=$PATH:~/Dotfiles/powerline/scripts
export PYTHONPATH=$PYTHONPATH:~/Dotfiles/powerline

# Make vim work better
alias vim='TERM=screen-256color vim'
alias v='TERM=screen-256color vim'

# Make emacs nicer
alias ec='emacsclient -c --alternate-editor ""'

# Enable virtualenvwrapper
VIRTUAL_ENV="/usr/local/bin/virtualenvwrapper.sh"
if [ -f "$VIRTUAL_ENV" ]; then
	export WORKON_HOME="~/.virtualenvs"
	mkdir -p "$WORKON_HOME"
	source "$VIRTUAL_ENV"
fi
