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
    
    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'vtar_tarea_vs_usuario_obj';

BEGIN
    
	V_MSQL := '
	CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||' (tar_id, usu_pendientes, usu_alerta, usu_supervisor, dd_tge_id_alerta, dd_tge_id_pendiente, zon_cod, pef_id)
AS
   SELECT tn.tar_id, tn.tar_id_dest usu_pendientes, -1 usu_alerta, -1 usu_supervisor, CASE
             WHEN (tn.tar_alerta IS NOT NULL AND tn.tar_alerta = 1)
                THEN NVL (tap.dd_tsup_id, 3)
             ELSE -1
          END dd_tge_id_alerta,
          CASE
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
             WHEN sta.dd_sta_gestor = 1
                THEN TO_CHAR (zonges.zon_cod)
             ELSE TO_CHAR (zonsup.zon_cod)
          END zon_cod, CASE
             WHEN sta.dd_sta_gestor = 1
                THEN pol.pef_id_gestor
             ELSE pol.pef_id_super
          END pef_id
     FROM '||V_ESQUEMA||'.tar_tareas_notificaciones tn INNER JOIN '||V_ESQUEMA||'.obj_objetivo obj ON tn.obj_id = obj.obj_id
          INNER JOIN '||V_ESQUEMA||'.pol_politica pol ON obj.pol_id = pol.pol_id
          LEFT JOIN '||V_ESQUEMA||'.zon_zonificacion zonges ON pol.zon_id_gestor = zonges.zon_id
          LEFT JOIN '||V_ESQUEMA||'.zon_zonificacion zonsup ON pol.zon_id_super = zonsup.zon_id
          LEFT JOIN '||V_ESQUEMA||'.tex_tarea_externa tex ON tn.tar_id = tex.tar_id
          LEFT JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id
          INNER JOIN '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base sta ON tn.dd_sta_id = sta.dd_sta_id
    WHERE tn.borrado = 0 AND (tn.tar_tarea_finalizada IS NULL OR tn.tar_tarea_finalizada = 0) AND tn.dd_ein_id = 7                                                                   -- CODIGO OBJETIVO'
	;
  
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

