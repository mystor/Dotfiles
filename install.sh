# Link Everything
bash link.sh

# Check if git is installed
git --version 2>&1 >/dev/null
if [ ! $? -eq 0 ]; then
    # Git is not installed
    echo "Git is not installed.  Please install it before running install.sh"
    exit 1
fi

# Install powerline if it isn't already installed
if [ ! -d "powerline" ]; then
    # It isn't, install it
    git clone https://github.com/Lokaltog/powerline.git powerline
fi

# Install vundle if it isn't already installed
if [ ! -d "vim/bundle/vundle" ]; then
    # It isn't, install it
    git clone https://github.com/gmarik/vundle.git vim/bundle/vundle
    vim +BundleInstall +qall # Actually run the install scripts
fi

