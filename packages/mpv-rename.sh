#!/bin/sh
# Append commit hash at the end of filename
# $1 = git_dir $2 = folder_name
cd $1
GIT=$(git rev-parse --short=7 HEAD)
mv $2 $2-git-${GIT}
