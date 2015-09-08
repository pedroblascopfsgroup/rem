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
    V_VIEWNAME VARCHAR2(30):= 'VTAR_ASU_VS_USU';

BEGIN


DBMS_OUTPUT.PUT_LINE('[INICIO]');

DBMS_OUTPUT.PUT_LINE('[INFO] Bloque scripts para la inclusión de un nuevo tipo del histórico de operaciones - Notificación - (3/7)');
DBMS_OUTPUT.PUT('[INFO] Modificación de la vista '||V_VIEWNAME||'...');

--/**
-- * Modificacion o creación de vista: Si existe modifica y si no, la crea como nueva - Script relanzable
-- *************************************************************/
execute immediate
'  CREATE OR REPLACE FORCE VIEW '||V_ESQUEMA||'.'||V_VIEWNAME||' (USU_ID, DES_ID, DD_TGE_ID, USU_ID_ORIGINAL, ASU_ID, GAS_ID, DD_EST_ID, ASU_FECHA_EST_ID, ASU_PROCESS_BPM, ASU_NOMBRE, EXP_ID, VERSION, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO, DD_EAS_ID, ASU_ASU_ID, ASU_OBSERVACION, SUP_ID, SUP_COM_ID, COM_ID, DCO_ID, ASU_FECHA_RECEP_DOC, USD_ID, DTYPE, DD_UCL_ID, REF_ASESORIA, LOTE, DD_TAS_ID, ASU_ID_EXTERNO, DD_PAS_ID, DD_GES_ID) AS  '||Chr(13)||Chr(10)||
'  SELECT usd.usu_id, '||Chr(13)||Chr(10)||
'      usd.des_id, '||Chr(13)||Chr(10)||
'      ges.dd_tge_id, '||Chr(13)||Chr(10)||
'      usd.usu_id usu_id_original, '||Chr(13)||Chr(10)||
'      asu.ASU_ID, '||Chr(13)||Chr(10)||
'      asu.GAS_ID, '||Chr(13)||Chr(10)||
'      asu.DD_EST_ID, '||Chr(13)||Chr(10)||
'      asu.ASU_FECHA_EST_ID, '||Chr(13)||Chr(10)||
'      asu.ASU_PROCESS_BPM, '||Chr(13)||Chr(10)||
'      asu.ASU_NOMBRE, '||Chr(13)||Chr(10)||
'      asu.EXP_ID, '||Chr(13)||Chr(10)||
'      asu.VERSION, '||Chr(13)||Chr(10)||
'      asu.USUARIOCREAR, '||Chr(13)||Chr(10)||
'      asu.FECHACREAR, '||Chr(13)||Chr(10)||
'      asu.USUARIOMODIFICAR, '||Chr(13)||Chr(10)||
'      asu.FECHAMODIFICAR, '||Chr(13)||Chr(10)||
'      asu.USUARIOBORRAR, '||Chr(13)||Chr(10)||
'      asu.FECHABORRAR, '||Chr(13)||Chr(10)||
'      asu.BORRADO, '||Chr(13)||Chr(10)||
'      asu.DD_EAS_ID, '||Chr(13)||Chr(10)||
'      asu.ASU_ASU_ID, '||Chr(13)||Chr(10)||
'      asu.ASU_OBSERVACION, '||Chr(13)||Chr(10)||
'      asu.SUP_ID, '||Chr(13)||Chr(10)||
'      asu.SUP_COM_ID, '||Chr(13)||Chr(10)||
'      asu.COM_ID, '||Chr(13)||Chr(10)||
'      asu.DCO_ID, '||Chr(13)||Chr(10)||
'      asu.ASU_FECHA_RECEP_DOC, '||Chr(13)||Chr(10)||
'      asu.USD_ID, '||Chr(13)||Chr(10)||
'      asu.DTYPE, '||Chr(13)||Chr(10)||
'      asu.DD_UCL_ID, '||Chr(13)||Chr(10)||
'      asu.REF_ASESORIA, '||Chr(13)||Chr(10)||
'      asu.LOTE, '||Chr(13)||Chr(10)||
'      asu.DD_TAS_ID, '||Chr(13)||Chr(10)||
'      asu.ASU_ID_EXTERNO, '||Chr(13)||Chr(10)||
'      asu.DD_PAS_ID, '||Chr(13)||Chr(10)||
'      asu.DD_GES_ID '||Chr(13)||Chr(10)||
'    FROM '||V_ESQUEMA||'.asu_asuntos asu '||Chr(13)||Chr(10)||
'    JOIN '||Chr(13)||Chr(10)||
'      (SELECT asu_id, usd_id, 4 dd_tge_id FROM  '||V_ESQUEMA||'.asu_asuntos WHERE usd_id IS NOT NULL '||Chr(13)||Chr(10)||
'      UNION ALL '||Chr(13)||Chr(10)||
'      SELECT asu_id, usd_id, dd_tge_id '||Chr(13)||Chr(10)||
'      FROM  '||V_ESQUEMA||'.gaa_gestor_adicional_asunto '||Chr(13)||Chr(10)||
'      WHERE borrado = 0 '||Chr(13)||Chr(10)||
'      ) ges '||Chr(13)||Chr(10)||
'    ON asu.asu_id = ges.asu_id '||Chr(13)||Chr(10)||
'    JOIN  '||V_ESQUEMA||'.usd_usuarios_despachos usd '||Chr(13)||Chr(10)||
'    ON ges.usd_id = usd.usd_id ';


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
