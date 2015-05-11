#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <numeroPeticion>"
    exit
fi

./create-run-scripts.sh DDL > 01-$1-DDL.sh
chmod +x 01-$1-DDL.sh

./create-run-scripts.sh DML > 02-$1-DML.sh
chmod +x 02-$1-DML.sh

./create-run-scripts.sh Grant > 03-${1}-Grant.sh
chmod +x 03-${1}-Grant.sh

