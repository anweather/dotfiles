#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
files_dir="$BASE_DIR/files"

for dotfile in `ls -1 $files_dir`; do
	test -f ~/.$dotfile && mv ~/.$dotfile ~/.$dotfile.bkup
	ln -s $files_dir/$dotfile ~/.$dotfile
done
