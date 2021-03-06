#!/bin/bash
echo Checking if npm is installed
npm="$(command -v npm)"
path="/usr/bin/npm"
if [ "$npm" == "$path" ];
    then
        echo Found npm
        echo Build tern
        if [ $1 == "vim" ]; 
            then
                cd ~/.vim/bundle/tern_for_vim/
                sudo npm install
                cd ~/.vim/bundle/completor.vim 
                make js
            else
                cd ~/.config/nvim/bundle/tern_for_vim
                sudo npm install
                cd ~/.config/nvim/bundle/completor.vim
                make js
        fi
        exit 0
    else
        echo npm is not installed!
        echo Please install npm and node.js to use better JS completion.
        exit 1
fi
