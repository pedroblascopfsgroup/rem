#!/bin/bash

FILE=~/.gitignore
FILE_LOCAL=$(dirname $0)/.gitignore

git config --global core.excludesfile $FILE


function find (){	
	touch $2

	if [ -z "$(grep $1 $2)" ]; then
		echo 0
	else
		echo 1
	fi
}


function _add (){
	if [ $(find $1 $2) -eq 0 ]; then
		echo $1 >> $2
	fi
}

function add (){
	_add $1 $FILE
}

function addLocal (){
	_add $1 $FILE_LOCAL
}

add .project
add .settings
add .classpath
add target
add bin

addLocal src
addLocal ClienteBankia
addLocal _new
addLocal .data
addLocal .revtmp
add .apodo
