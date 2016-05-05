--/*
--##########################################
--## AUTOR=Oscar Dorado
--## FECHA_CREACION=20160429
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.4
--## INCIDENCIA_LINK=PRODUCTO-1322
--## PRODUCTO=SI
--## Finalidad: Versionado en git
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
    
    V_NOMBRE_VISTA VARCHAR2(30 CHAR):= 'vtar_tarea_vs_usuario_acuerdos';

BEGIN
    
	V_MSQL := '
	CREATE OR REPLACE VIEW '||V_ESQUEMA||'.'||V_NOMBRE_VISTA||'
	AS SELECT TAR_ID
    , t.tar_id_dest usu_pendientes
    --, 0 usu_espera
    , -1 usu_alerta, t.dd_tge_id_supervisor usu_supervisor
    , t.dd_tge_id_alerta
    , t.dd_tge_id_pendiente
    ,NULL ZON_COD
  	,NULL PEF_ID
  FROM '||V_ESQUEMA||'.VTAR_TAREA_VS_TGE t
  WHERE t.dd_sta_id IN  (SELECT tarbs.DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE tarbs WHERE tarbs.DD_STA_CODIGO = ''ACP_ACU''
			OR tarbs.DD_STA_CODIGO = ''REV_ACU'' OR tarbs.DD_STA_CODIGO = ''GST_CIE_ACU'' OR tarbs.DD_STA_CODIGO = ''NOTIF_ACU'')
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

