--/*
--##########################################
--## AUTOR=JOSEVI
--## FECHA_CREACION=20150618
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=FASE-1345
--## PRODUCTO=SI
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
	
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);
    V_VIEWNAME VARCHAR2(30):= 'VTAR_TAREA_VS_TGE';

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');

DBMS_OUTPUT.PUT_LINE('[INFO] Bloque scripts para la inclusión de un nuevo tipo del histórico de operaciones - Notificación - (2/7)');
DBMS_OUTPUT.PUT('[INFO] Modificación de la vista '||V_VIEWNAME||'...');

--/**
-- * Modificacion o creación de vista: Si existe modifica y si no, la crea como nueva - Script relanzable
-- *************************************************************/
execute immediate
'  CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_VIEWNAME||' (DD_TGE_ID_PENDIENTE, DD_TGE_ID_ALERTA, DD_TGE_ID_SUPERVISOR, ASU_ID, TAR_ID, DD_STA_ID, TAR_ID_DEST) AS  '||Chr(13)||Chr(10)||
'  SELECT '||Chr(13)||Chr(10)||
'  CASE '||Chr(13)||Chr(10)||
'    WHEN (sta.dd_sta_id = 700 OR sta.dd_sta_id = 701) THEN -1 '||Chr(13)||Chr(10)||
'    WHEN NVL (tap.dd_tge_id, 0) != 0 THEN tap.dd_tge_id '||Chr(13)||Chr(10)||
'    WHEN sta.dd_tge_id IS NULL THEN CASE sta.dd_sta_gestor  WHEN 0 THEN 3 ELSE 2 END '||Chr(13)||Chr(10)||
'    ELSE sta.dd_tge_id '||Chr(13)||Chr(10)||
'  END dd_tge_id_pendiente '||Chr(13)||Chr(10)||
'--  , CASE '||Chr(13)||Chr(10)||
'--    WHEN (tar.tar_en_espera IS NOT NULL AND tar.tar_en_espera = 1) THEN 1 '||Chr(13)||Chr(10)||
'--    ELSE 0 '||Chr(13)||Chr(10)||
'--  END en_espera '||Chr(13)||Chr(10)||
'  , CASE '||Chr(13)||Chr(10)||
'    WHEN (tar.tar_alerta IS NOT NULL AND tar.tar_alerta = 1) THEN NVL (tap.dd_tsup_id, 3) '||Chr(13)||Chr(10)||
'    ELSE -1 '||Chr(13)||Chr(10)||
'  END dd_tge_id_alerta '||Chr(13)||Chr(10)||
'  , NVL (tap.dd_tsup_id, 3) dd_tge_id_supervisor, tar.ASU_ID, tar.TAR_ID, tar.dd_sta_id, tar.tar_id_dest '||Chr(13)||Chr(10)||
'FROM '||V_ESQUEMA||'.tar_tareas_notificaciones tar '||Chr(13)||Chr(10)||
'  JOIN '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base sta ON tar.dd_sta_id = sta.dd_sta_id '||Chr(13)||Chr(10)||
'  JOIN '||V_ESQUEMA_M||'.dd_ein_entidad_informacion ein on tar.dd_ein_id = ein.dd_ein_id '||Chr(13)||Chr(10)||
'  LEFT JOIN '||V_ESQUEMA||'.tex_tarea_externa tex ON tar.tar_id = tex.tar_id '||Chr(13)||Chr(10)||
'  LEFT JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id '||Chr(13)||Chr(10)||
' -- LEFT JOIN '||V_ESQUEMA_M||'.USU_USUARIOS USU ON TAR.USUARIOCREAR = USU.USU_USERNAME '||Chr(13)||Chr(10)||
'WHERE   '||Chr(13)||Chr(10)||
'  (tar.tar_tarea_finalizada IS NULL OR tar.tar_tarea_finalizada = 0)  '||Chr(13)||Chr(10)||
'  AND ein.dd_ein_codigo IN (3, 5, 2, 9, 10)  '||Chr(13)||Chr(10)||
'  AND tar.borrado = 0  ';

--/* Recompilar nueva vista
--************************************************************/
execute immediate ('alter view '||V_ESQUEMA||'.'||V_VIEWNAME||' compile');


COMMIT;

DBMS_OUTPUT.PUT_LINE('OK modificada');

DBMS_OUTPUT.PUT_LINE('[FIN]');



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/
EXIT;