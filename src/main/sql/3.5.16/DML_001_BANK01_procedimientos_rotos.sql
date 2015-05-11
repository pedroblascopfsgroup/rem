--/*
--##########################################
--## AUTOR=OSCAR_DORADO
--## FECHA_CREACION=20150429
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=
--## INCIDENCIA_LINK=BKNIVDOS-1514
--## PRODUCTO=NO
--## Finalidad: DML
--##            
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    VARIABLE1 VARCHAR2(25 CHAR):= '#VARIABLE1#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    V_MSQL VARCHAR2(4000 CHAR);

 
BEGIN


execute immediate 'MERGE INTO '||V_ESQUEMA||'.prc_procedimientos prc
   USING (SELECT tar.prc_id, tpo1.dd_tpo_id, tpo2.dd_tpo_id nuevo
            FROM '||V_ESQUEMA||'.tar_tareas_notificaciones tar JOIN '||V_ESQUEMA||'.prc_procedimientos prc1 ON tar.prc_id = prc1.prc_id
                 JOIN '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo1 ON prc1.dd_tpo_id = tpo1.dd_tpo_id
                 JOIN '||V_ESQUEMA||'.tex_tarea_externa tex ON tar.tar_id = tex.tar_id
                 JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
                 JOIN '||V_ESQUEMA||'.dd_tpo_tipo_procedimiento tpo2 ON tap.dd_tpo_id = tpo2.dd_tpo_id
           WHERE tpo1.dd_tpo_codigo <> tpo2.dd_tpo_codigo AND (tar.tar_tarea_finalizada IS NULL OR tar.tar_tarea_finalizada = 0)
			GROUP BY TAR.PRC_ID, tpo1.dd_tpo_id, tpo2.dd_tpo_id
) tmp
   ON (prc.prc_id = tmp.prc_id)
   WHEN MATCHED THEN
      UPDATE
         SET dd_tpo_id = tmp.nuevo, usuariomodificar = ''BKNVDS-1514'', fechamodificar = SYSDATE';



COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN] INCIDENCIA');
    

EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;