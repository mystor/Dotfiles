#!/bin/bash
DOTFILES=$(pwd) # This should probably be ~/Dotfiles - some configs depend on it

# Check if git is installed
git --version 2>&1 >/dev/null
if [ ! $? -eq 0 ]; then
    # Git is not installed
    echo "Git isn't installed. Install it before running install.sh"
    exit 1
fi

# Ensure all submodules are up to date
git submodule update --init --recursive

# All of the files which need to be created
files=(
    "$HOME/.vim
        ln -s '$DOTFILES/vim' ~/.vim"

    "$HOME/.vimrc
        ln -s '$DOTFILES/vim/vimrc' ~/.vimrc"

    "$HOME/.bashrc
        ln -s '$DOTFILES/sh/bashrc' ~/.bashrc"

    "$HOME/.bash_profile
        ln -s '$DOTFILES/sh/bash_profile' ~/.bash_profile"

    "$HOME/.oh-my-zsh
        ln -s '$DOTFILES/sh/oh-my-zsh' ~/.oh-my-zsh"

    "$HOME/.zshrc
        ln -s '$DOTFILES/sh/zshrc' ~/.zshrc"

    "$HOME/.emacs
        ln -s '$DOTFILES/emacs/emacs' ~/.emacs"

    "$HOME/.global_gitignore
        ln -s '$DOTFILES/global_gitignore' ~/.global_gitignore"

    "$HOME/.amethyst
        ln -s '$DOTFILES/amethyst' ~/.amethyst"
)

# Link every file!
for item in "${files[@]}"; do
    IFS=$'\n' read -rd '' -a parts <<< "$item" # Split the item on newlines
    f=${parts[0]} # The file
    c=${parts[1]} # The command

    # Try to perform the action
    if [ -e $f ]; then
        read -p "$f already exists. Clobber? (Y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Creating $f"
            rm -rf "$f"             # Scary!
            eval "$c"               # Perform the command
        fi
    else
        echo "Creating $f"
        eval "$c"
    fi
done

# Gitignore
git config --global core.excludesfile ~/.global_gitignore

# Vundle (vim package manager)
if [ ! -d "vim/bundle/vundle" ]; then
    echo "Setting up Vundle"
    git clone https://github.com/gmarik/vundle.git vim/bundle/vundle
    vim +BundleInstall +qall
else
    echo "Skipping Vundle setup"
fi
