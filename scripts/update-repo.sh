#!/bin/bash

main() {
    packages_dir=$(pwd)
    for dir in $packages_dir/*-prefix ; do
        local name=$(echo $(basename $dir) | sed -e 's|-prefix$||')
        local src_dir=$packages_dir/$name-prefix/src/$name
        local stamp_dir=$packages_dir/$name-prefix/src/$name-stamp

        if [[ -d "$src_dir/.git" ]] ; then
            # Skip updating these packages
            if [[ $name =~ ^(angle|megasdk)$ ]]; then
                continue
            fi

            gitupdate $name $src_dir $stamp_dir &
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

    echo "Updating $name"
    git -C $src_dir reset --hard @{u} > /dev/null

    result=$(git -C $src_dir pull 2>&1)
    result_module=$(git -C $src_dir submodule update --remote --recursive 2>&1)

    if [[ ! "$result" =~ up[-\ ]to[-\ ]date ]] || [[ ! -z $result_module ]]; then
        echo "Deleting stamp files for $name"
        find $stamp_dir -maxdepth 1 -type f ! -iname "*.cmake" -size 0c -delete # remove stamp files to force rebuild
    fi
}

# Execute
main
