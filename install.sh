#!/bin/sh

echo "\
Hello $(whoami)!
This Dotfiles plugin installation script will do the following for you:
- Setup Git repository in you home folder. You will be asked to enter remote address, username, and email
- Write necessery files:
    ~/.oh-my-zsh/custom/plugins/dotfiles/dotfiles.plugin.zsh
    ~/.gitignore
    ~/.gitinclude
Should script start installation [y/n]?";

read isInstallationConfirmed

if [ $isInstallationConfirmed = "n" ]
then
  echo "Plugin won't be installed"
elif [ $isInstallationConfirmed = "y" ]
then
  echo "Installing..."

  # curl plugin into oh-my-zsh
  mkdir -p ~/.oh-my-zsh/custom/plugins/dotfiles
  curl -sL https://raw.githubusercontent.com/vladmyr/dotfiles-plugin/master/dotfiles.plugin.zsh -o ~/.oh-my-zsh/custom/plugins/dotfiles/dotfiles.plugin.zsh
  
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

  echo "\
Installation complete!

Now make sure to enable plugin in .zshrc, eg:
  plugins=(... dotfiles)
Afterwards execute
  > source ~/.zshrc
  > dotfiles -h
To verify plugin is installed correctly.

To uninstall the plugin revert change in .zshrc and execute:
  > rm -rf .git .gitignore .gitinclude .oh-my-zsh/custom/plugins/dotfiles
"
else
  echo "\
Unrecognised user input: $isInstallationConfirmed
Script terminated.
"
fi
