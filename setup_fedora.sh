#!/bin/bash

codedir=$HOME/code
vimdir=$HOME/.vim
datetime="`date +%Y%m%d%H%M%S`"
dotfiles=$HOME/.dotfiles

# update git color for untracked files to white
git config --global color.status.untracked white
git config --global color.status.changed "white normal dim"
git config --global color.status.nobranch "red bold ul"

# update git color for diff
git config --global color.diff.old "yellow reverse dim"

# add difftool
git config --global diff.guitool meld
git config --global diff.tool vimdiff
git config --global difftool.prompt false

# vim as editor
git config --global core.editor vim

# core excludes file
git config --global core.excludesfile ~/.gitignore


# directory colors for ls
LS_COLORS='ow=01;36;40'
export LS_COLORS

sudo dnf install -y @cinnamon-desktop
sudo dnf install -y vim-enhanced
sudo dnf install -y chicken
sudo dnf install -y redhat-rpm-config
sudo dnf install -y nnn
sudo dnf install -y guile
sudo dnf install -y htop
sudo dnf install -y sbcl
sudo dnf install -y gitk
sudo dnf install -y java-devel
sudo dnf install -y dconf-editor
sudo dnf install -y clisp
sudo dnf install -y kdiff3
sudo dnf install -y meld

# apt install packages for ubuntu
#sudo apt update
#sudo apt install -y leiningen
#sudo apt install -y postgresql
#sudo apt install -y mysql-server
#sudo apt install -y libmysqlclient-dev
#sudo apt install -y rvm
#sudo apt install -y rawtherapee
#sudo apt install -y libxml2-utils
#sudo apt install -y cmake
#sudo apt install -y fonts-font-awesome
#sudo apt install -y libreoffice
#sudo apt install -y mutt
#sudo apt install -y guile-3.0
#sudo apt install -y net-tools
#sudo apt install -y ufw
#sudo apt install -y openssh-server
#sudo apt install -y xdg-desktop-portal
#sudo apt install -y clang
#sudo apt install -y python3-pip
#sudo apt install -y 1password

flatpak install flathub com.spotify.Client
flatpak install flathub org.videolan.VLC
flatpak install flathub com.obsproject.Studio
flatpak install flathub us.zoom.Zoom
flatpak install flathub com.jetbrains.IntelliJ-IDEA-Ultimate
flatpak install flathub com.jetbrains.DataGrip

# enable firewall
#sudo ufw enable
#sudo sfw logging on
#sudo ufw allow ssh

echo "Checking to see if $codedir is already created"
if ! [ -d "$codedir" ]; then
    echo "it is not... calling mkdir $codedir"
    mkdir $codedir
fi

if [ -d "$vimdir" ]; then
    echo "$vimdir already exists.. moving to $vimdir.$datetime"
    mv $vimdir $vimdir.$datetime
    echo "cloning vimconfig: git clone git@github.com:scwfri/vimconfig $vimdir"
    git clone git@github.com:scwfri/vimconfig $vimdir
fi

for repo in AdventOfCode hackn noteit vim
do
    if ! [ -d "$codedir/$repo" ]; then
        echo "cloning: git clone git@github.com:scwfri/$repo $codedir/$repo"
        git clone git@github.com:scwfri/$repo $codedir/$repo
    fi
done

for file in tmux.conf bashrc bash_aliases inputrc csirc zshrc gitignore
do 
    if [ -f "$HOME/.$file" ]; then
        echo "$HOME/$file already exists.. moving to $HOME/.$file.$datetime"
    fi

    echo "running: ln -s $dotfiles/$file $HOME/.$file..."
    ln -s $dotfiles/$file $HOME/.$file
done

if ! [ -d "$HOME/git" ]; then
    echo "ln -s $home/.dotfiles/git $home/git"
    ln -s $home/.dotfiles/git $home/git
fi

# python pip installation
/usr/bin/python3 -m pip install --user autopep8
/usr/bin/python3 -m pip install --user pylint
/usr/bin/python3 -m pip install --user black
/usr/bin/python3 -m pip install --user yapf
/usr/bin/python3 -m pip install --user pycodestyle

# install sbt
curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
sudo dnf install sbt

# install linenoise for chicken
CSC_OPTIONS='-I/usr/include/chicken' chicken-install linenoise -s

# install quicklisp
curl -o /tmp/ql.lisp http://beta.quicklisp.org/quicklisp.lisp
sbcl --no-sysinit --no-userinit --load /tmp/ql.lisp \
       --eval '(quicklisp-quickstart:install :path "~/.quicklisp")' \
       --eval '(ql:add-to-init-file)' \
       --quit

source ~/.bashrc
