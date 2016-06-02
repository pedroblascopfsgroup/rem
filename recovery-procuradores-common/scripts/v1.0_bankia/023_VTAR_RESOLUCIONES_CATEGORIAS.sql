CREATE OR REPLACE FORCE VIEW bank01.vtar_resoluciones_categorias (usu_pendientes,
                                                                  cat_id,
                                                                  COUNT
                                                                 )
AS
   SELECT   vprocu.usu_pendientes, vprocu.cat_id, COUNT (*)
       FROM (SELECT DISTINCT usu_pendientes, cat_id, tar_id
                        FROM vtar_tarea_vs_procuradores) vprocu
   GROUP BY (vprocu.cat_id, vprocu.usu_pendientes);
