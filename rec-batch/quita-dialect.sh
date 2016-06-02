#!/bin/bash


for xml in $(find . -name '*.xml'); do
	[[ ! -z "$(dirname $xml | grep 'src/test')" ]] && continue
	sed -i 's/\.\${entity.dialect}//g' $xml
	sed -i 's/\.Oracle10gDialect//g' $xml
	sed -i 's/\.Oracle9iDialect//g' $xml
done