--/*
--##########################################
--## AUTOR=DANIEL GUTIÉRREZ
--## FECHA_CREACION=20151023
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

BEGIN


--##CREACION DE TABLA, PK y FK de tabla

  DBMS_OUTPUT.PUT('[INFO] Vista VTAR_TAREA_VS_TGE: CREADA...');	     	 
	EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW '||V_ESQUEMA||'.VTAR_TAREA_VS_TGE
  (DD_TGE_ID_PENDIENTE, DD_TGE_ID_ALERTA, DD_TGE_ID_SUPERVISOR, ASU_ID, TAR_ID, DD_STA_ID, TAR_ID_DEST) AS 
  SELECT CASE
             WHEN (sta.dd_sta_id = 700 OR sta.dd_sta_id = 701)
                THEN -1
             WHEN NVL (tap.dd_tge_id, 0) != 0
                THEN tap.dd_tge_id
             WHEN sta.dd_tge_id IS NULL
                THEN CASE sta.dd_sta_gestor
                       WHEN 0
                          THEN 3
                       ELSE 2
                    END
             ELSE sta.dd_tge_id
          END dd_tge_id_pendiente,
          CASE
             WHEN (tar.tar_alerta IS NOT NULL AND tar.tar_alerta = 1)
                THEN NVL (tap.dd_tsup_id, 3)
             ELSE -1
          END dd_tge_id_alerta, NVL (tap.dd_tsup_id, 3) dd_tge_id_supervisor, tar.asu_id, tar.tar_id, tar.dd_sta_id, etn.tar_id_dest
     FROM '||V_ESQUEMA||'.tar_tareas_notificaciones tar 
          JOIN ETN_EXTAREAS_NOTIFICACIONES etn ON etn.tar_id = tar.tar_id
          JOIN '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base sta ON tar.dd_sta_id = sta.dd_sta_id
          JOIN '||V_ESQUEMA_M||'.dd_ein_entidad_informacion ein ON tar.dd_ein_id = ein.dd_ein_id
          LEFT JOIN '||V_ESQUEMA||'.tex_tarea_externa tex ON tar.tar_id = tex.tar_id
          LEFT JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
    WHERE (tar.tar_tarea_finalizada IS NULL OR tar.tar_tarea_finalizada = 0) AND ein.dd_ein_codigo IN (3, 5, 2, 9, 10) AND tar.borrado = 0';
  DBMS_OUTPUT.PUT_LINE('OK');

  
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso ejecutado CORRECTAMENTE. Vista creada.');
	
COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT