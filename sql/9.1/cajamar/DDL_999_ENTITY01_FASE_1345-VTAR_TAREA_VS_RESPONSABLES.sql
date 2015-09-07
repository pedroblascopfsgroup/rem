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
    V_VIEWNAME VARCHAR2(30):= 'VTAR_TAREA_VS_RESPONSABLES';

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');

DBMS_OUTPUT.PUT_LINE('[INFO] Bloque scripts para la inclusión de un nuevo tipo del histórico de operaciones - Notificación - (4/7)');
DBMS_OUTPUT.PUT('[INFO] Modificación de la vista '||V_VIEWNAME||'...');

--/**
-- * Modificacion o creación de vista: Si existe modifica y si no, la crea como nueva - Script relanzable
-- *************************************************************/
execute immediate
'  CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_VIEWNAME||' (TAR_ID, DD_TGE_ID_ALERTA, DD_TGE_ID_PENDIENTE, DD_TGE_ID_SUPERVISOR, USU_PENDIENTES, USU_ALERTA, USU_SUPERVISOR) AS  '||Chr(13)||Chr(10)||
'  SELECT tar_id, MAX(dd_tge_id_alerta) AS dd_tge_id_alerta '||Chr(13)||Chr(10)||
'        , MAX(dd_tge_id_pendiente) as dd_tge_id_pendiente, MAX(dd_tge_id_supervisor) as dd_tge_id_supervisor, MAX(NVL (usu_pendientes, -1)) usu_pendientes '||Chr(13)||Chr(10)||
'        , MAX(NVL (usu_alerta, -1)) usu_alerta, MAX(NVL (usu_supervisor, -1)) usu_supervisor '||Chr(13)||Chr(10)||
'        --,MAX(NVL (en_espera, 0)) en_espera '||Chr(13)||Chr(10)||
'     FROM ( '||Chr(13)||Chr(10)||
'     SELECT vtar.tar_id, vtar.dd_tge_id_alerta '||Chr(13)||Chr(10)||
'                  , vtar.dd_tge_id_pendiente, vtar.dd_tge_id_supervisor '||Chr(13)||Chr(10)||
'                  , DECODE (vusu.dd_tge_id, vtar.dd_tge_id_pendiente, vusu.usu_id) usu_pendientes '||Chr(13)||Chr(10)||
'                  --, vtar.en_espera en_espera '||Chr(13)||Chr(10)||
'                  , DECODE (vusu.dd_tge_id, vtar.dd_tge_id_alerta, vusu.usu_id) usu_alerta '||Chr(13)||Chr(10)||
'                  , DECODE (vusu.dd_tge_id, vtar.dd_tge_id_supervisor, vusu.usu_id) usu_supervisor '||Chr(13)||Chr(10)||
'      FROM '||V_ESQUEMA||'.VTAR_TAREA_VS_TGE vtar '||Chr(13)||Chr(10)||
'        JOIN '||V_ESQUEMA||'.vtar_asu_vs_usu vusu ON vtar.asu_id = vusu.asu_id '||Chr(13)||Chr(10)||
'      ) '||Chr(13)||Chr(10)||
'  WHERE (usu_pendientes>0 '||Chr(13)||Chr(10)||
'    -- or en_espera>0 '||Chr(13)||Chr(10)||
'    or usu_alerta>0) '||Chr(13)||Chr(10)||
'  GROUP BY tar_id  ';

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