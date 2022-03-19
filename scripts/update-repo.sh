#!/bin/bash

main() {
    packages_dir=$(pwd)
    for dir in $packages_dir/*-prefix ; do
        local name=$(echo $(basename $dir) | sed -e 's|-prefix$||')
        [[ ! -z $1 ]] && local src_dir=$1/$name || local src_dir=$packages_dir/$name-prefix/src/$name
        [[ ! -z $2 ]] && local stamp_dir=$2/packages/$name-prefix/src/$name-stamp || local stamp_dir=$packages_dir/$name-prefix/src/$name-stamp
        [[ ! -z $3 ]] && local stamp_dir2=$3/packages/$name-prefix/src/$name-stamp

        if [[ -d "$src_dir/.git" ]] ; then
            # Skip updating these packages
            if [[ $name =~ ^(angle|megasdk)$ ]]; then
                continue
            fi

            gitupdate $name $src_dir $stamp_dir $stamp_dir2 &
        # TODO: handle hg repo
        fi
    done
    wait
}

gitupdate()
{
    local name=$1
    local src_dir=$2
    local stamp_dir=$3
    local stamp_dir2=$4

    echo "Updating $name"
    git -C $src_dir reset --hard @{u} > /dev/null

    result=$(git -C $src_dir pull 2>&1)
    result_module=$(git -C $src_dir submodule update --remote --recursive 2>&1)

    if [[ ! "$result" =~ up[-\ ]to[-\ ]date ]] || [[ ! -z $result_module ]]; then
        echo "Deleting stamp files for $name"
        find $stamp_dir -maxdepth 1 -type f ! -iname "*.cmake" -size 0c -delete # remove stamp files to force rebuild
        find $stamp_dir2 -maxdepth 1 -type f ! -iname "*.cmake" -size 0c -delete # remove stamp files to force rebuild
    fi
}

# Execute
# ex: ./update-repo.sh /home/git_source /home/build32 /home/build64
main $1 $2 $3
