#!/bin/bash
# Generado manualmente
 
cd /datos/usuarios/ops-haya/recBI/var/opt/MicroStrategy/bin
./mstrcmdmgr  -n "Recovery_BI" -u "administrator" -p "" -f  "/aplicaciones/ops-haya/shells/update_cache.scp" -o "/log/ops-haya/update_cache.out"
