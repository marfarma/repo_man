#!/bin/bash

if [[ "$1" == "" ]]; then
  echo -n 'Enter a name for the new git repository: '
  read REPONAME
else
  REPONAME=$1
fi

if [[ "$2" == "" ]]; then
  DESCRIPTION="Edit /srv/git/${REPONAME}.git/description to change this"
else
  DESCRIPTION=$2
fi


mkdir /srv/git/${REPONAME}.git
chgrp 'domain^users' /srv/git/${REPONAME}.git
chmod g+ws /srv/git/${REPONAME}.git
cd /srv/git/${REPONAME}.git
GIT_DIR="/srv/git/${REPONAME}.git" git init --shared=group
touch /srv/git/${REPONAME}.git/git-daemon-export-ok
echo $DESCRIPTION >description

cat << E0F
The repository ${REPONAME} has been created. Now you need to add some content.

Is this a completely new project?
  mkdir ${REPONAME}
  cd ${REPONAME}
  git init
  touch README
  git add README
  git commit -m 'first commit'
  git remote add origin git.lab.viget.com:/srv/git/${REPONAME}.git
  git push origin master
      
Do you have an existing git repository to push into this one?
  cd existing_git_repo
  git remote add origin git.lab.viget.com:/srv/git/${REPONAME}.git
  git push origin master
E0F
