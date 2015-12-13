#!/bin/bash

echo "*************** GCL"
cat log/GCL.log
echo "*************** Cirbe"
cat log/Cirbe.log
for fichero in `ls log/*s.log`;
do
    echo "*************** "$fichero
    cat $fichero
done
