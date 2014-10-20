#!/bin/zsh

USAGE="
Usage: `basename $0` [--update]
"
install_xmonad=false
install_zsh=false
force_install=false
install_vim=false

while [ "$1" != "" ]; do
    case "$1"  in
        --xmonad )
            install_xmonad=true
            ;;
        --zsh )
            install_zsh=true
            ;;
        --vim )
            install_vim=true
            ;;
        --force-install )
            force_install=true
            ;;
        * )
            echo $USAGE
            exit 1
    esac
    shift
done

function setup_X
{
    cp ./defaults/.xinitrc ~/
    cp ./defaults/.Xdefaults ~/ 
}

function setup_xmonad
{
    setup_X
    sudo apt-get install xmonad dmenu xmobar
    mkdir ~/.xmonad
    cp ./defaults/xmonad.hs ~/.xmonad/
    cp ./defaults/.dmenurc ~/
    cp ./defaults/.xmobarrc ~/
    echo "installing xmonad"
}

function setup_zsh
{
    if ! [[ -d ~/.oh-my-zsh ]] ; then
        git clone git@github.com:mamikonyana/oh-my-zsh.git ~/.oh-my-zsh
    else
        # TODO(arsen): Check that it point to a correct repository.
        if $force_install ; then
            echo "Deleting the contents of ~/.oh-my-zsh"
            rm -rf ~/.oh-my-zsh
            git clone git@github.com:mamikonyana/oh-my-zsh.git ~/.oh-my-zsh
        fi
    fi
    echo "Copied default zsh config into ~/.zshrc"
    cp ./defaults/zshrc.zsh-template ~/.zshrc
    # Install esqaw theme
    # TODO(arsen): Figure out a way to get this variable from shell, it's there in terminal
    ZSH_CUSTOM=~/.oh-my-zsh/custom
    mkdir -p $ZSH_CUSTOM/themes
    curl https://raw.githubusercontent.com/mamikonyana/esqaw-zsh-theme/master/esqaw.zsh-theme -o $ZSH_CUSTOM/themes/esqaw.zsh-theme
    echo "Done Setting up zsh."
}

function setup_vim
{
    echo "Installing vim using setup-vim.sh script"
   ./setup-vim.sh 
}

if $install_xmonad ; then
    setup_xmonad
fi

if $install_zsh ; then
    setup_zsh
fi

if $install_vim ; then
    setup_vim
fi
