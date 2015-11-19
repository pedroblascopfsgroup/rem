#!/bin/bash

for file in `ls bankia/*.sh`;
do
    dos2unix $file
done
