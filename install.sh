#!/bin/sh

echo "\
Hello $(whoami)!
This Dotfiles plugin installation script will do the following for you:
- Setup Git repository in you home folder. You will be asked to enter remote address, username, and email
- Write necessery files:
    ~/.oh-my-zsh/custom/plugins/dotfiles/dotfiles.plugin.zsh
    ~/.gitignore
    ~/.gitinclude
- Commit and push to remote repository
Should script start installation [y/n]?";

read isInstallationConfirmed

if [ $isInstallationConfirmed = "n" ]
then
  echo "Plugin won't be installed"
elif [ $isInstallationConfirmed = "y" ]
then
  echo "Installing..."

  # write .gitignore & .gitinclude
  echo "\
.zshrc
.oh-my-zsh/custom/themes/*
.oh-my-zsh/custom/plugins/*" > ~/.gitinclude
  echo "\
/*
!.gitignore
!.gitinclude" > ~/.gitignore
# initialize git
  git init ~
  echo "Enter Git user name:"
  read gitUsername
  git config -f ~/.git/config user.name "$gitUsername"

  echo "Enter Git email:"
  read gitEmail
  git config -f ~/.git/config user.email "$gitEmail"

  cd ~
  git add .
  git commit -m "initial commit"

  echo "\
Installation complete!

Now make sure to enable plugin in .zshrc, eg:
  plugins=(git dotfiles)
Afterwards execute
  > source ~/.zshrc
  > dotfiles -h
To verify plugin is installed correctly
"
else
  echo "\
Unrecognised user input: $isInstallationConfirmed
Script terminated.
"
fi
