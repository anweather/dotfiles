#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

link_files="$BASE_DIR/link_files"
bash_files="$BASE_DIR/bash_files"
git_files="$BASE_DIR/git_files"

for dotfile in `ls -1 $bash_files`; do
	source_str="source $bash_files/$dotfile"

	if [[ -f ~/.$dotfile ]]; then
		# File exists - make sure we don't already have our source in it
		result=`grep "$source_str" ~/.$dotfile`

		if [[ $result == "" ]]; then
			echo "$source_str" >> ~/.$dotfile
		fi
	else
		# File does not exist
		echo "$source_str" >> ~/.$dotfile
	fi
done

for dotfile in `ls -1 $link_files`; do
	test -L ~/.$dotfile && rm ~/.$dotfile
	test -f ~/.$dotfile && mv ~/.$dotfile ~/.$dotfile.bkup
	ln -s $link_files/$dotfile ~/.$dotfile
done


declare lock_file=/tmp/lock_
function locked_exec {
	hash_function=`which md5 >/dev/null 2>&1 && echo "md5" || echo "base64"`
	lock_file+=`caller | $hash_function`
	if mkdir $lock_file 2>/dev/null; then
		eval $@
		rmdir $lock_file
	else
		echo "Could not get lock ($lock_file). Did not run $1"
	fi
}

function setup_git_config {
	tools_gitconfig="${git_files}/gitconfig"
	if ! head -n2 ~/.gitconfig | grep "path" | grep "$tools_gitconfig" >/dev/null; then
		sed -i.bkup "s|path =.*|path = $tools_gitconfig|" ~/.gitconfig
		rm ~/.gitconfig.bkup
	fi
	if ! head -n2 ~/.gitconfig | grep "include\|path" >/dev/null; then
		echo -e "[include]\n  path = $tools_gitconfig\n$(cat ~/.gitconfig)" > ~/.gitconfig
	fi
}

locked_exec setup_git_config
