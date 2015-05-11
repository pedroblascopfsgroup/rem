ALTER TABLE LIN001.RES_RESOLUCIONES_MASIVO ADD  RES_PRC_ID  NUMBER(16);

ALTER TABLE LIN001.RES_RESOLUCIONES_MASIVO ADD (
  CONSTRAINT FK_RES_PRC_ID 
 FOREIGN KEY (RES_PRC_ID)
 REFERENCES LIN001.PRC_PROCEDIMIENTOS (PRC_ID));
 
 
/*RELLENAR EL PRC_ID*/
UPDATE res_resoluciones_masivo res
   SET res_prc_id = (SELECT tar.prc_id
                       FROM tex_tarea_externa tex INNER JOIN tar_tareas_notificaciones tar
                            ON tex.tar_id = tar.tar_id
                      WHERE tex_id = res.res_tex_id);