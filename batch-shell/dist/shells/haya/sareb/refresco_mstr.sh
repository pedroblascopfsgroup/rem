#!/bin/bash
# Generado manualmente
 
cd /datos/usuarios/ops-haya/recBI/var/opt/MicroStrategy/bin
./mstrcmdmgr  -n "Recovery_BI" -u "administrator" -p "" -f  "$DIR_SHELLS/update_cache.scp" -o "$DIR_CONTROL_LOG/update_cache.out"
