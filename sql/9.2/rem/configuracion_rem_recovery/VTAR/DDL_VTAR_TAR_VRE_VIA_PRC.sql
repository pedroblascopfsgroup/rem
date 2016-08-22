
  CREATE OR REPLACE FORCE VIEW "REM01"."VTAR_TAR_VRE_VIA_PRC" ("TAR_ID", "VRE") AS 
  select t.tar_id, NVL(p.PRC_SALDO_RECUPERACION,0) vre
            from prc_procedimientos p, TAR_TAREAS_NOTIFICACIONES t
    where p.prc_id = t.prc_id 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ;
 
