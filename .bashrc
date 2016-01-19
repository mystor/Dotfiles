###
# Get the prompt working nicely
###
export VIRTUAL_ENV_DISABLE_PROMPT=true

function _dotfiles_gitdir() {
	gitdir="$1"

	while [[ ! -e "$gitdir/.git" ]]; do
		if [[ $gitdir == '/' ]]; then
			return 1
		fi
		gitdir=$(dirname $gitdir)
	done

	echo "$gitdir"
}

function _dotfiles_gitpwd() {
	###
	# Prints the current working directory as a subdirectory of the current project.
	###

	local git_name git_dir real_path
	git_name=''
	git_dir="$(_dotfiles_gitdir $PWD)"
	# "$(git rev-parse --show-toplevel 2>/dev/null)"
	if [[ $? == 0 ]]; then
		git_name=$(basename "$git_dir")

		# Submodule status detection
		git_superdir=$(_dotfiles_gitdir "$(dirname "$git_dir")")
		if [[ $? == 0 ]]; then
			git_name="$(basename $git_superdir):$git_name"
		fi
	else
		if [[ "${PWD##$HOME}" != "$PWD" ]]; then # Inside Home
			git_dir="$HOME"
			git_name='~'
		else                                     # Not inside home
			git_dir='/'
			git_name='/'
		fi
	fi

	rest_path="${PWD##$git_dir}"

	echo "$git_name$rest_path"
}

export PS1='
\u@\h $(_dotfiles_gitpwd)
\$ '

alias ec='emacsclient -n'

source ~/.bashlocal
