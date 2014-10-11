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

# Make ec start emacs and bring it to the front
# The || true makes the script succeed when oascript doesn't exist
# (Example: on Linux)
function ec {
    emacsclient -c -n -a "" $* && \
    osascript -e 'tell app "Emacs" to activate' 2> /dev/null || true
}

# Enable virtualenvwrapper
VIRTUAL_ENV="/usr/local/bin/virtualenvwrapper.sh"
if [ -f "$VIRTUAL_ENV" ]; then
	export WORKON_HOME="$HOME/.virtualenvs"
	mkdir -p "$WORKON_HOME"
	source "$VIRTUAL_ENV"
fi
