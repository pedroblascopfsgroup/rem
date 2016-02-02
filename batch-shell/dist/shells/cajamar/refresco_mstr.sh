#!/bin/bash
# Generado manualmente
 
cd /recovery/i-server/var/opt/MicroStrategy/bin
./mstrcmdmgr  -n "Recovery_BI" -u "administrator" -p "1pfsgroup" -f  "/recovery/batch-server/shells/update_cache.scp" -o "/recovery/batch-server/shells/update_cache.out"
