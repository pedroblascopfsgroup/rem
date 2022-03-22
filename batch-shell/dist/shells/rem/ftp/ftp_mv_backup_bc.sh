#!/bin/bash

lftp -u usr_pfsbc,9f32bfd20b -p 22 sftp://intercambio2.haya.es <<EOF
cd Archivos/recep/
mv $1 backup/
bye
EOF
