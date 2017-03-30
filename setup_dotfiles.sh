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
