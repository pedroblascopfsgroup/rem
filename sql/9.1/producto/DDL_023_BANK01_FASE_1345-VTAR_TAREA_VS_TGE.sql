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

DBMS_OUTPUT.PUT_LINE('[INFO] Bloque scripts para la inclusión de un nuevo tipo del histórico de operaciones - Notificación - (2/4)');
DBMS_OUTPUT.PUT('[INFO] Modificación de la vista '||V_VIEWNAME||'...');

--/**
-- * Modificacion o creación de vista: Si existe modifica y si no, la crea como nueva - Script relanzable
-- *************************************************************/
execute immediate(
'  CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_VIEWNAME||' (DD_TGE_ID_PENDIENTE, DD_TGE_ID_ESPERA, DD_TGE_ID_ALERTA, DD_TGE_ID_SUPERVISOR, TAR_ID, CLI_ID, EXP_ID, ASU_ID, TAR_TAR_ID, SPR_ID, SCX_ID, DD_EST_ID, DD_EIN_ID, DD_STA_ID, TAR_CODIGO, TAR_TAREA, TAR_DESCRIPCION, TAR_FECHA_FIN, TAR_FECHA_INI, TAR_EN_ESPERA, TAR_ALERTA, TAR_TAREA_FINALIZADA, TAR_EMISOR, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, PRC_ID, CMB_ID, SET_ID, TAR_FECHA_VENC, OBJ_ID, TAR_FECHA_VENC_REAL, DTYPE, NFA_TAR_REVISADA, NFA_TAR_FECHA_REVIS_ALER, NFA_TAR_COMENTARIOS_ALERTA, DD_TRA_ID, CNT_ID, TAR_DESTINATARIO, TAR_TIPO_DESTINATARIO, TAR_ID_DEST, PER_ID, RPR_REFERENCIA, T_REFERENCIA) AS  '||Chr(13)||Chr(10)||
'  SELECT  CASE '||Chr(13)||Chr(10)||
'               WHEN (sta.dd_sta_id = 700 OR sta.dd_sta_id = 701) '||Chr(13)||Chr(10)||
'                  THEN -1                                                                                                                               -- Quitamos las anotaciones '||Chr(13)||Chr(10)||
'               WHEN NVL (tap.dd_tge_id, 0) != 0 '||Chr(13)||Chr(10)||
'                  THEN tap.dd_tge_id '||Chr(13)||Chr(10)||
'               WHEN sta.dd_tge_id IS NULL '||Chr(13)||Chr(10)||
'                  THEN CASE sta.dd_sta_gestor '||Chr(13)||Chr(10)||
'                         WHEN 0 '||Chr(13)||Chr(10)||
'                            THEN 3 '||Chr(13)||Chr(10)||
'                         ELSE 2 '||Chr(13)||Chr(10)||
'                      END '||Chr(13)||Chr(10)||
'               ELSE sta.dd_tge_id '||Chr(13)||Chr(10)||
'            END dd_tge_id_pendiente '||Chr(13)||Chr(10)||
'-- tipo de gestor para las tareas en espera '||Chr(13)||Chr(10)||
'            --,tar.tar_en_espera, tar.tar_en_espera,tap.dd_tge_id, '||Chr(13)||Chr(10)||
'            ,CASE '||Chr(13)||Chr(10)||
'               WHEN (tar.tar_en_espera IS NOT NULL AND tar.tar_en_espera = 1) '||Chr(13)||Chr(10)||
'                  THEN --(select vusu.usu_id from '||V_ESQUEMA_M||'.usu_usuarios where tar_emisor = usu_nombre) '||Chr(13)||Chr(10)||
'                  vusu.dd_tgE_id '||Chr(13)||Chr(10)||
'               ELSE -1 '||Chr(13)||Chr(10)||
'            END dd_tge_id_espera '||Chr(13)||Chr(10)||
'-- tipo de gestor para las alertas '||Chr(13)||Chr(10)||
'            , CASE '||Chr(13)||Chr(10)||
'               WHEN (tar.tar_alerta IS NOT NULL AND tar.tar_alerta = 1) '||Chr(13)||Chr(10)||
'                  THEN NVL (tap.dd_tsup_id, 3) '||Chr(13)||Chr(10)||
'               ELSE -1 '||Chr(13)||Chr(10)||
'            END dd_tge_id_alerta, NVL (tap.dd_tsup_id, 3) dd_tge_id_supervisor, tar.TAR_ID, tar.CLI_ID, tar.EXP_ID, tar.ASU_ID, tar.TAR_TAR_ID, tar.SPR_ID, tar.SCX_ID, tar.DD_EST_ID, '||Chr(13)||Chr(10)||
'            tar.DD_EIN_ID, tar.DD_STA_ID, tar.TAR_CODIGO, tar.TAR_TAREA, tar.TAR_DESCRIPCION, tar.TAR_FECHA_FIN, tar.TAR_FECHA_INI, tar.TAR_EN_ESPERA, tar.TAR_ALERTA, '||Chr(13)||Chr(10)||
'            tar.TAR_TAREA_FINALIZADA, tar.TAR_EMISOR, tar.VERSION, tar.USUARIOCREAR, tar.FECHACREAR, tar.USUARIOMODIFICAR, tar.FECHAMODIFICAR, tar.USUARIOBORRAR, tar.FECHABORRAR, '||Chr(13)||Chr(10)||
'            tar.BORRADO, tar.PRC_ID, tar.CMB_ID, tar.SET_ID, tar.TAR_FECHA_VENC, tar.OBJ_ID, tar.TAR_FECHA_VENC_REAL, tar.DTYPE, tar.NFA_TAR_REVISADA, tar.NFA_TAR_FECHA_REVIS_ALER, '||Chr(13)||Chr(10)||
'            tar.NFA_TAR_COMENTARIOS_ALERTA, tar.DD_TRA_ID, tar.CNT_ID, tar.TAR_DESTINATARIO, tar.TAR_TIPO_DESTINATARIO, tar.TAR_ID_DEST, tar.PER_ID, tar.RPR_REFERENCIA, '||Chr(13)||Chr(10)||
'            tar.T_REFERENCIA '||Chr(13)||Chr(10)||
'       FROM tar_tareas_notificaciones tar  '||Chr(13)||Chr(10)||
'            JOIN '||V_ESQUEMA_M||'.dd_sta_subtipo_tarea_base sta ON tar.dd_sta_id = sta.dd_sta_id '||Chr(13)||Chr(10)||
'            JOIN '||V_ESQUEMA_M||'.dd_ein_entidad_informacion ein ON tar.dd_ein_id = ein.dd_ein_id '||Chr(13)||Chr(10)||
'            LEFT JOIN '||V_ESQUEMA||'.tex_tarea_externa tex ON tar.tar_id = tex.tar_id '||Chr(13)||Chr(10)||
'            LEFT JOIN '||V_ESQUEMA||'.tap_tarea_procedimiento tap ON tex.tap_id = tap.tap_id '||Chr(13)||Chr(10)||
'            left JOIN '||V_ESQUEMA||'.vtar_asu_vs_usu vusu ON tar.asu_id = vusu.asu_id  '||Chr(13)||Chr(10)||
'      WHERE 1 = 1 AND ein.dd_ein_codigo IN (3, 5, 2, 9, 10)                                                                                                                     -- solo asuntos y procedimientos '||Chr(13)||Chr(10)||
'            AND tar.borrado = 0 AND (tar.tar_tarea_finalizada IS NULL OR tar.tar_tarea_finalizada = 0) '||Chr(13)||Chr(10)||
'   --AND TAR_ID_DEST=1    '||Chr(13)||Chr(10)||
'   ORDER BY tar.tar_fecha_venc ');


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

EXIT

