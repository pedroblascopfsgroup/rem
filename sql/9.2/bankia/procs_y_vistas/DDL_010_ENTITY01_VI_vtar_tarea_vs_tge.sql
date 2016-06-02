--/*
--##########################################
--## AUTOR=Óscar
--## FECHA_CREACION=20160503
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=PRODUCTO-1322
--## PRODUCTO=SI
--## Finalidad: DDL para versionado en git
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'vtar_tarea_vs_tge';

BEGIN
    
	V_MSQL := '
	CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' (dd_tge_id_pendiente, dd_tge_id_alerta, dd_tge_id_supervisor, asu_id, tar_id, dd_sta_id, tar_id_dest)
AS
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
          END dd_tge_id_pendiente
--  , CASE
--    WHEN (tar.tar_en_espera IS NOT NULL AND tar.tar_en_espera = 1) THEN 1
--    ELSE 0
--  END en_espera
          ,
          CASE
             WHEN (tar.tar_alerta IS NOT NULL AND tar.tar_alerta = 1)
                THEN NVL (tap.dd_tsup_id, 3)
             ELSE -1
          END dd_tge_id_alerta, NVL (tap.dd_tsup_id, 3) dd_tge_id_supervisor, tar.asu_id, tar.tar_id, tar.dd_sta_id, tar.tar_id_dest
     FROM '||V_ESQUEMA||'.tar_tareas_notificaciones tar JOIN '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base sta ON tar.dd_sta_id = sta.dd_sta_id
          JOIN '||V_ESQUEMA_M||'.dd_ein_entidad_informacion ein ON tar.dd_ein_id = ein.dd_ein_id
          LEFT JOIN '||V_ESQUEMA||'.tex_tarea_externa tex ON tar.tar_id = tex.tar_id
          LEFT JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
    -- LEFT JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON TAR.USUARIOCREAR = USU.USU_USERNAME
   WHERE  (tar.tar_tarea_finalizada IS NULL OR tar.tar_tarea_finalizada = 0) AND ein.dd_ein_codigo IN (3, 5, 2, 9, 10) AND tar.borrado = 0
';
  
 EXECUTE IMMEDIATE V_MSQL;
 DBMS_OUTPUT.PUT_LINE('[INFO] '||V_NOMBRE_VISTA||' Creada o reemplazada');     

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

