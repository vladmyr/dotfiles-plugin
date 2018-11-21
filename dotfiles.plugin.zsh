function dotfiles_gitInclude {
  pwd=$(pwd)
  filepath=".gitinclude"
  while IFS= read -r line
  do
    git add -f "$line"
  done < "$filepath"
}

function dotfiles_hasStagedFiles {
  diffList=$(git diff --name-only --cached | cat)
  [ ! -z ${diffList// } ] && return
  false
}

function dotfiles_gitStage {
  dotfiles_gitInclude
  git add .
  if dotfiles_hasStagedFiles; 
  then 
    cGreen='\033[0;32m'
    cNone='\033[0m'
    echo -e "Staged changes:\n${cGreen}$(git diff --name-only --cached | cat)${cNone}"
  fi
}

function dotfiles_gitCommit {
  if dotfiles_hasStagedFiles;
  then
    git commit -m "$(date +%Y.%m.%d_%H:%M:%S) from $(whoami)@$(hostname)"
  fi
}

function dotfiles_gitStageCommit {
  dotfiles_gitStage
  dotfiles_gitCommit
}

function dotfiles_gitUpload {
  dotfiles_gitStage
  dotfiles_gitCommit
  git push
}

function dotfiles_gitDownload {
  git pull --rebase
}

function dotfiles {
  if [ "$1" = "-u" ] || [ "$1" = "--upload" ]
  then
    dotfiles_gitUpload
  elif [ "$1" = "-d" ] || [ "$1" = "--download" ]
  then
    dotfiles_gitDownload
  elif [ "$1" = "-c" ] || [ "$1" = "--commit" ]
  then
    dotfiles_gitStageCommit
  else
    echo "\
Dotfiles synchronization tool.
Options:
  -c, --commit        commit changes in dotfiles
  -u, --upload        upload dotfiles to remote repository
  -d, --download      download dotfiles from remote repository
  -h, --help          print usage interface\
"
  fi 
}