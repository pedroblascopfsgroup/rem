#!/bin/bash
TEMPLATE=default-template
LIST=list-all-shells.txt

for shell in $(cat $LIST); do
	cp $TEMPLATE ../../dist/shells/$shell
	chmod +x ../../dist/shells/$shell
done
