#!/bin/sh
# Append tag, commit's length and hash in folder name
# $1 = git_dir $2 = folder_name
cd $1
git_revision=$(git rev-parse --short @{u})
tag=$(git describe --tags $(git rev-list --tags --max-count=1))
length=$(git rev-list --count $tag..$git_revision)
git_revision="git-$git_revision"
version="$tag+$length-$git_revision"

mv $2 $2-${version}
