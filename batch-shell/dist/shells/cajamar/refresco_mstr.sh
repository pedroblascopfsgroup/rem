#!/bin/bash
# Generado manualmente
 
cd /datos/usuarios/recovecb/recBI/var/opt/MicroStrategy/bin
./mstrcmdmgr  -n "Recovery_BI" -u "administrator" -p "1pfsgroup" -f  "/aplicaciones/recovecb/shells/update_cache.scp" -o "/log/recovecb/update_cache.out"
