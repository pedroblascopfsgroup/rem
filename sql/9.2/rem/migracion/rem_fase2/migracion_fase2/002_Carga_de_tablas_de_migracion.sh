#! /bin/bash

rm CTLs_DATs/logs/*.log
rm CTLs_DATs/rejects/*.bad
rm CTLs_DATs/bad/*.bad
./loader_migracion_rem.sh $1 
