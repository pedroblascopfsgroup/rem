--/*
--##########################################
--## AUTOR=MANUEL MEJIAS
--## FECHA_CREACION=20150507
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.3.13_rc01
--## INCIDENCIA_LINK=HR-835
--## PRODUCTO=NO
--##
--## Finalidad:
--## INSTRUCCIONES: 
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
    
BEGIN
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET DD_TSUP_ID = (SELECT gestor.DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR gestor WHERE gestor.DD_TGE_CODIGO = ''DULI'') '
				|| ' WHERE DD_TPO_ID IN (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO IN ( '
				|| ' ''H001'',''H002'',''H003'',''H004'',''H005'',''H006'',''H007'',''H008'',''H011'',''H015'',''H016'',''H018'',''H020'', '
				|| ' ''H022'',''H024'',''H026'',''H028'',''H030'',''H032'',''H036'',''H038'',''H040'',''H042'',''H044'',''H046'',''H048'', '
				|| ' ''H050'',''H052'',''H054'',''H058'',''H062'',''H060'',''H064'',''H065'',''H066'',''P400'')) '
                || ' AND DD_TSUP_ID = (SELECT gestor.DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR gestor WHERE gestor.DD_TGE_CODIGO = ''DUCO'') '
				;

				
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
	COMMIT;
	
	
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET DD_TSUP_ID = (SELECT gestor.DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR gestor WHERE gestor.DD_TGE_CODIGO = ''GULI'') '
				|| ' WHERE DD_TPO_ID IN (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO IN ( '
				|| ' ''H001'',''H002'',''H003'',''H004'',''H005'',''H006'',''H007'',''H008'',''H011'',''H015'',''H016'',''H018'',''H020'', '
				|| ' ''H022'',''H024'',''H026'',''H028'',''H030'',''H032'',''H036'',''H038'',''H040'',''H042'',''H044'',''H046'',''H048'', '
				|| ' ''H050'',''H052'',''H054'',''H058'',''H062'',''H060'',''H064'',''H065'',''H066'',''P400'')) '
                || ' AND DD_TSUP_ID = (SELECT gestor.DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR gestor WHERE gestor.DD_TGE_CODIGO = ''GUCO'') '
				;

				
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
    COMMIT;

    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET DD_TSUP_ID = (SELECT gestor.DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR gestor WHERE gestor.DD_TGE_CODIGO = ''SULI'') '
				|| ' WHERE DD_TPO_ID IN (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO IN ( '
				|| ' ''H001'',''H002'',''H003'',''H004'',''H005'',''H006'',''H007'',''H008'',''H011'',''H015'',''H016'',''H018'',''H020'', '
				|| ' ''H022'',''H024'',''H026'',''H028'',''H030'',''H032'',''H036'',''H038'',''H040'',''H042'',''H044'',''H046'',''H048'', '
				|| ' ''H050'',''H052'',''H054'',''H058'',''H062'',''H060'',''H064'',''H065'',''H066'',''P400'')) '
                || ' AND DD_TSUP_ID = (SELECT gestor.DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR gestor WHERE gestor.DD_TGE_CODIGO = ''SUCO'') '
				;
    

	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
    COMMIT;

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET DD_STA_ID = (SELECT subtipo.DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE subtipo '
				|| ' WHERE subtipo.DD_TGE_ID = (SELECT gestor.DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR gestor WHERE gestor.DD_TGE_CODIGO = ''DULI'')) '
				|| ' WHERE DD_TPO_ID IN (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO IN ( '
				|| ' ''H001'',''H002'',''H003'',''H004'',''H005'',''H006'',''H007'',''H008'',''H011'',''H015'',''H016'',''H018'',''H020'', '
				|| ' ''H022'',''H024'',''H026'',''H028'',''H030'',''H032'',''H036'',''H038'',''H040'',''H042'',''H044'',''H046'',''H048'', '
				|| ' ''H050'',''H052'',''H054'',''H058'',''H062'',''H060'',''H064'',''H065'',''H066'',''P400'')) '
				|| ' AND DD_STA_ID = (SELECT subtipo.DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE subtipo '
				|| ' WHERE subtipo.DD_TGE_ID = (SELECT gestor.DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR gestor WHERE gestor.DD_TGE_CODIGO = ''DUCO'')) '
				;
	
	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
    COMMIT;

    
    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET DD_STA_ID = (SELECT subtipo.DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE subtipo '
				|| ' WHERE subtipo.DD_TGE_ID = (SELECT gestor.DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR gestor WHERE gestor.DD_TGE_CODIGO = ''GULI'')) '
				|| ' WHERE DD_TPO_ID IN (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO IN ( '
				|| ' ''H001'',''H002'',''H003'',''H004'',''H005'',''H006'',''H007'',''H008'',''H011'',''H015'',''H016'',''H018'',''H020'', '
				|| ' ''H022'',''H024'',''H026'',''H028'',''H030'',''H032'',''H036'',''H038'',''H040'',''H042'',''H044'',''H046'',''H048'', '
				|| ' ''H050'',''H052'',''H054'',''H058'',''H062'',''H060'',''H064'',''H065'',''H066'',''P400'')) '
				|| ' AND DD_STA_ID = (SELECT subtipo.DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE subtipo '
				|| ' WHERE subtipo.DD_TGE_ID = (SELECT gestor.DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR gestor WHERE gestor.DD_TGE_CODIGO = ''GUCO'')) '
				;

	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
    COMMIT;

    V_MSQL := 'UPDATE '||V_ESQUEMA||'.TAP_TAREA_PROCEDIMIENTO '
				|| ' SET DD_STA_ID = (SELECT subtipo.DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE subtipo '
				|| ' WHERE subtipo.DD_TGE_ID = (SELECT gestor.DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR gestor WHERE gestor.DD_TGE_CODIGO = ''SULI'')) '
				|| ' WHERE DD_TPO_ID IN (SELECT DD_TPO_ID FROM '||V_ESQUEMA||'.DD_TPO_TIPO_PROCEDIMIENTO WHERE DD_TPO_CODIGO IN ( '
				|| ' ''H001'',''H002'',''H003'',''H004'',''H005'',''H006'',''H007'',''H008'',''H011'',''H015'',''H016'',''H018'',''H020'', '
				|| ' ''H022'',''H024'',''H026'',''H028'',''H030'',''H032'',''H036'',''H038'',''H040'',''H042'',''H044'',''H046'',''H048'', '
				|| ' ''H050'',''H052'',''H054'',''H058'',''H062'',''H060'',''H064'',''H065'',''H066'',''P400'')) '
				|| ' AND DD_STA_ID = (SELECT subtipo.DD_STA_ID FROM '||V_ESQUEMA_M||'.DD_STA_SUBTIPO_TAREA_BASE subtipo '
				|| ' WHERE subtipo.DD_TGE_ID = (SELECT gestor.DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR gestor WHERE gestor.DD_TGE_CODIGO = ''SUCO'')) '
				;

	DBMS_OUTPUT.PUT_LINE(V_MSQL);
    EXECUTE IMMEDIATE V_MSQL; 
    COMMIT;
 
EXCEPTION
     
    -- Opcional: Excepciones particulares que se quieran tratar
    -- Como esta, por ejemplo:
    -- WHEN TABLE_EXISTS_EXCEPTION THEN
        -- DBMS_OUTPUT.PUT_LINE('Ya se ha realizado la copia en la tabla TMP_MOV_'||TODAY);
 
 
    -- SIEMPRE DEBE HABER UN OTHERS
    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/
 
EXIT;