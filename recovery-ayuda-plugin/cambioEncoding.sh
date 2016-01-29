#!/bin/sh
for f in `find . -type f`
do
        encoding=`file --mime-encoding $f | sed "s/.*://"`
        if [ ! "$encoding" = " utf-8" ]; then
                iconv -f $encoding -t utf-8 $f -o $f
        fi
done
