--/*
--##########################################
--## AUTOR=Alberto b.
--## FECHA_CREACION=20151114
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=gestionVencidos
--## INCIDENCIA_LINK=CMREC-1175
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
SET DEFINE OFF;
DECLARE
    V_MSQL VARCHAR2(4000 CHAR);
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    seq_count number(3); -- Vble. para validar la existencia de las Secuencias.
    table_count number(3); -- Vble. para validar la existencia de las Tablas.
    v_column_count number(3); -- Vble. para validar la existencia de las Columnas.
    v_constraint_count number(3); -- Vble. para validar la existencia de las Constraints.
    err_num NUMBER; -- Numero de errores
    err_msg VARCHAR2(2048); -- Mensaje de error
  	
BEGIN	
    -- LOOP Insertando valores en FUN_FUNCIONES
    DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA_M||'.DD_SUP_SUPERVISORES...');
    
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_SUP_SUPERVISORES WHERE DD_SUP_CODIGO = ''SUCON''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN				
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_SUP_SUPERVISORES... Ya existe ');
	ELSE		
		V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_SUP_SUPERVISORES (DD_SUP_ID, DD_SUP_CODIGO, DD_SUP_DESCRIPCION, DD_SUP_DESCRIPCION_LARGA, DD_TGE_SUP, DD_TGE_GES, VERSION, USUARIOCREAR, FECHACREAR,BORRADO) VALUES ('||V_ESQUEMA_M||'.S_DD_SUP_SUPERVISORES.NEXTVAL, ''SUCON'', ''Supervisor concursal'',''Supervisor concursal'', (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUCON''),(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GESCON''), ''0'', ''CPI'',SYSDATE,''0'')';
		DBMS_OUTPUT.PUT_LINE('INSERTANDO: REGISTRO EN DD_SUP_SUPERVISORES');
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.FUN_FUNCIONES... Datos del diccionario insertado');
    
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA_M||'.DD_SUP_SUPERVISORES WHERE DD_SUP_CODIGO = ''SUCHRE''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	IF V_NUM_TABLAS > 0 THEN				
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA_M || '.DD_SUP_SUPERVISORES... Ya existe');
	ELSE		
		V_MSQL := 'INSERT INTO '|| V_ESQUEMA_M ||'.DD_SUP_SUPERVISORES (DD_SUP_ID, DD_SUP_CODIGO, DD_SUP_DESCRIPCION, DD_SUP_DESCRIPCION_LARGA, DD_TGE_SUP, DD_TGE_GES, VERSION, USUARIOCREAR, FECHACREAR,BORRADO) VALUES ('||V_ESQUEMA_M||'.S_DD_SUP_SUPERVISORES.NEXTVAL, ''SUCHRE'', ''Supervisor Control gestión HRl'',''Supervisor Control gestión HRl'', (SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''SUCHRE''),(SELECT DD_TGE_ID FROM '||V_ESQUEMA_M||'.DD_TGE_TIPO_GESTOR WHERE DD_TGE_CODIGO = ''GESCHRE''), ''0'', ''CPI'',SYSDATE,''0'')';
		DBMS_OUTPUT.PUT_LINE('INSERTANDO: REGISTRO EN DD_SUP_SUPERVISORES');
		EXECUTE IMMEDIATE V_MSQL;
	END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[FIN] '||V_ESQUEMA_M||'.FUN_FUNCIONES... Datos del diccionario insertado');
    
    

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
  	