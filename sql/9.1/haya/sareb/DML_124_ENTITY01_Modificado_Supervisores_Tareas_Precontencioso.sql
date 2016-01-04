--/*
--##########################################
--## AUTOR=ALBERTO SOLER
--## FECHA_CREACION=20151201
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=PRODUCTO-354
--## PRODUCTO=SI 
--## Finalidad: Actualiza los campos de supervisores de las tareas de precontencioso (TSUP) y devuelve a null a TGE_ID ya que no son los supervisores
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Version inicial
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
    V_TABLA_TMP VARCHAR2(25 CHAR); -- Configuracion tabla temporal
    V_TABLA_TMP2 VARCHAR2(25 CHAR); -- Configuracion tabla temporal
    
BEGIN	
	V_TABLA_TMP := 'DD_TPO_TIPO_PROCEDIMIENTO';
	DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DE LOS SUPERVISORES PARA TAREAS DE PRECONTENCIOSO');
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE DD_TPO_ID IN ( SELECT DD_TPO_ID FROM '||V_TABLA_TMP||' WHERE DD_TPO_CODIGO = ''PCO'') AND DD_STA_ID in (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_TGE_ID IN (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GEXT''))';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    DBMS_OUTPUT.PUT_LINE('EL NUMERO DE FILAS ES: '||V_NUM_TABLAS);
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DE LOS SUPERVISORES PARA TAREAS DE LETRADO');
    	
		V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUP_PCO'') WHERE DD_TPO_ID IN ( SELECT DD_TPO_ID FROM '||V_TABLA_TMP||' WHERE DD_TPO_CODIGO = ''PCO'') AND DD_STA_ID in (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_TGE_ID IN (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GEXT''))';
    	EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE LOS SUPERVISORES PARA TAREAS DE LETRADO');

    END IF;
    
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO WHERE DD_TPO_ID IN ( SELECT DD_TPO_ID FROM '||V_TABLA_TMP||' WHERE DD_TPO_CODIGO = ''PCO'') AND DD_STA_ID NOT in (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_TGE_ID IN (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GEXT''))';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    DBMS_OUTPUT.PUT_LINE('EL NUMERO DE FILAS ES: '||V_NUM_TABLAS);
    IF V_NUM_TABLAS > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'... ACTUALIZACION DEL RESTO SUPERVISORES');
    	
		V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET DD_TSUP_ID = (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''PREDOC'') WHERE DD_TPO_ID IN ( SELECT DD_TPO_ID FROM '||V_TABLA_TMP||' WHERE DD_TPO_CODIGO = ''PCO'') AND DD_STA_ID not in (SELECT DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE WHERE DD_TGE_ID IN (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GEXT''))';
    	EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DEL RESTO SUPERVISORES');
    END IF;

    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... YA HEMOS ACTUALIZADO SUPERVISORES, PONEMOS A NULL DD_TGE_ID');
    V_SQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO SET DD_TGE_ID = NULL WHERE DD_TPO_ID IN ( SELECT DD_TPO_ID FROM '||V_TABLA_TMP||' WHERE DD_TPO_CODIGO = ''PCO'')';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA||'... ACTUALIZACION DE LOS SUPERVISORES PARA TAREAS DE PRECONTENCIOSO');
    
    COMMIT;
    
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