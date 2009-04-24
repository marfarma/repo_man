#!/bin/bash

if [[ "$1" == "" ]]; then
  echo -n 'Enter a name for the new svn repository: '
  read REPONAME
else
  REPONAME=$1
fi

repo_location="/srv/svn/${REPONAME}"

svnadmin create $repo_location
cd ${repo_location}/conf
head -n -1 /srv/svn/.shared/svnserve.conf-sample > svnserve.conf
echo "realm = ${REPONAME}" >> svnserve.conf
chown -R nobody:nobody $repo_location

temp_dir=$$
svn co file://${repo_location} $temp_dir > /dev/null 2>&1
cd $temp_dir
mkdir {branches,tags,trunk}
svn add * > /dev/null 2>&1
svn commit -m "Initial layout" > /dev/null 2>&1
cd ..
rm -rf $tmp_dir

cat << E0F
The repository ${REPONAME} has been created. Its URL is:
  svn://svn.lab.viget.com/${REPONAME}/trunk
E0F
