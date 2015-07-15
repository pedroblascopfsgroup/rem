--- tabla GAA_GESTOR ADICIONAL_ASUNTO

INSERT INTO GAA_GESTOR_ADICIONAL_ASUNTO (GAA_ID, ASU_ID, USD_ID, DD_TGE_ID, VERSION, USUARIOCREAR, FECHACREAR, BORRADO)
SELECT 
  S_GAA_GESTOR_ADICIONAL_ASUNTO.NEXTVAL
  , ASU_ID
  , 5321 -- Usuario: GESTOR
  , 2 -- GEXT
  ,0, 'BRUNO', SYSDATE, 0
FROM ASU_ASUNTOS;

COMMIT;



-- Solución bugs datos INTEHAYA

-- El vampo DD_STA_ID de las tareas 'P420_registrarAceptacion' de BANKIA está a NULL
--update TAR_TAREAS_NOTIFICACIONES set dd_sta_id = 39 where dd_sta_id is null;
update TAR_TAREAS_NOTIFICACIONES set dd_sta_id = (select dd_sta_id from HAYAMASTER.dd_sta_subtipo_tarea_base where dd_sta_codigo='814')  where dd_sta_id is null;

COMMIT;


-- El campo TAR_TAREA no tenía el valor correcto
/*20150303: ROBERTO, esto ya está creado correctamente.*/
/*
MERGE INTO TAR_TAREAS_NOTIFICACIONES TAR
USING (
  select TAR.TAR_ID, TAR.TAR_TAREA, TAR_DESCRIPCION, TAP.TAP_DESCRIPCION
  from TAR_TAREAS_NOTIFICACIONES TAR
    JOIN TEX_TAREA_EXTERNA TEX ON TAR.TAR_ID = TEX.TAR_ID
    JOIN TAP_TAREA_PROCEDIMIENTO TAP ON TEX.TAP_ID = TAP.TAP_ID
  WHERE TAR_TAREA <> TAP_DESCRIPCION
) TMP
ON (TAR.TAR_ID = TMP.TAR_ID)
WHEN MATCHED THEN UPDATE SET TAR.TAR_TAREA = TMP.TAP_DESCRIPCION
;

COMMIT;
*/


-- No se habían creado las instancias de los BPM
-- Requiere DDL para crear el SP ALTA_BPM_INSTANCES
/*20150303: ROBERTO, esto ya se ha hecho correctamente.*/
/*
BEGIN
  ALTA_BPM_INSTANCES();
END;
*/
