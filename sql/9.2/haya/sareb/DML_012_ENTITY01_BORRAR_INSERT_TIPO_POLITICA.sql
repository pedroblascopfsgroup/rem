--/*
--##########################################
--## AUTOR=Kevin Fernández
--## FECHA_CREACION=20160406
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.2
--## INCIDENCIA_LINK= PRODUCTO-1151
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
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquemas  
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquemas  
    V_NUM_REG NUMBER(16); -- Vble. para validar la existencia de los registros. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
BEGIN
	-- Comprobar existencia.
	V_MSQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.TPL_TIPO_POLITICA WHERE TPL_CODIGO = ''TPLMAN01''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_REG;

	IF V_NUM_REG > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.TPL_TIPO_POLITICA... Ya existen los registros');
	ELSE
		-- Borrar Diccionarios existentes.
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.TPL_TIPO_POLITICA... Borrar todas las opciones anteriores');
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.TPL_TIPO_POLITICA SET BORRADO = 1';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TPL_TIPO_POLITICA registros anteriores borrados');
		
		DBMS_OUTPUT.PUT_LINE('[INICIO] '||V_ESQUEMA||'.TPL_TIPO_POLITICA... Insertar nuevos registros');
		
		-- Añadir nuevos Diccionarios.
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA (TPL_ID,TPL_CODIGO,TEN_ID,TPL_DESCRIPCION,TPL_DESCRIPCION_LARGA,TPL_PRIORIDAD,TPL_PLAZO_VIGENCIA,DD_POL_ID,TPL_PESO,VERSION,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.NEXTVAL,''TPLMAN01'',(SELECT TEN_ID FROM '||V_ESQUEMA||'.TEN_TENDENCIA WHERE TEN_CODIGO = ''MAN''),''A mantener'',''A mantener'',''0'',''0'',(SELECT DD_POL_ID FROM '||V_ESQUEMA||'.DD_POL_POLITICAS WHERE DD_POL_CODIGO = ''2''),''0'',''0'',''PROD-1151'',SYSDATE)';
		EXECUTE IMMEDIATE V_MSQL;
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA (TPL_ID,TPL_CODIGO,TEN_ID,TPL_DESCRIPCION,TPL_DESCRIPCION_LARGA,TPL_PRIORIDAD,TPL_PLAZO_VIGENCIA,DD_POL_ID,TPL_PESO,VERSION,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.NEXTVAL,''TPLSEG01'',(SELECT TEN_ID FROM '||V_ESQUEMA||'.TEN_TENDENCIA WHERE TEN_CODIGO = ''MAN''),''A seguir'',''A seguir'',''0'',''0'',(SELECT DD_POL_ID FROM '||V_ESQUEMA||'.DD_POL_POLITICAS WHERE DD_POL_CODIGO = ''2''),''0'',''0'',''PROD-1151'',SYSDATE)';
		EXECUTE IMMEDIATE V_MSQL;
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA (TPL_ID,TPL_CODIGO,TEN_ID,TPL_DESCRIPCION,TPL_DESCRIPCION_LARGA,TPL_PRIORIDAD,TPL_PLAZO_VIGENCIA,DD_POL_ID,TPL_PESO,VERSION,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.NEXTVAL,''TPLREF01'',(SELECT TEN_ID FROM '||V_ESQUEMA||'.TEN_TENDENCIA WHERE TEN_CODIGO = ''DES''),''A refinanciar'',''A refinanciar'',''0'',''0'',(SELECT DD_POL_ID FROM '||V_ESQUEMA||'.DD_POL_POLITICAS WHERE DD_POL_CODIGO = ''2''),''0'',''0'',''PROD-1151'',SYSDATE)';
		EXECUTE IMMEDIATE V_MSQL;
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA (TPL_ID,TPL_CODIGO,TEN_ID,TPL_DESCRIPCION,TPL_DESCRIPCION_LARGA,TPL_PRIORIDAD,TPL_PLAZO_VIGENCIA,DD_POL_ID,TPL_PESO,VERSION,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.NEXTVAL,''TPLREE01'',(SELECT TEN_ID FROM '||V_ESQUEMA||'.TEN_TENDENCIA WHERE TEN_CODIGO = ''DES''),''A reestructurar'',''A reestructurar'',''0'',''0'',(SELECT DD_POL_ID FROM '||V_ESQUEMA||'.DD_POL_POLITICAS WHERE DD_POL_CODIGO = ''2''),''0'',''0'',''PROD-1151'',SYSDATE)';
		EXECUTE IMMEDIATE V_MSQL;
		
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA (TPL_ID,TPL_CODIGO,TEN_ID,TPL_DESCRIPCION,TPL_DESCRIPCION_LARGA,TPL_PRIORIDAD,TPL_PLAZO_VIGENCIA,DD_POL_ID,TPL_PESO,VERSION,USUARIOCREAR,FECHACREAR) VALUES ('||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.NEXTVAL,''TPLEXT01'',(SELECT TEN_ID FROM '||V_ESQUEMA||'.TEN_TENDENCIA WHERE TEN_CODIGO = ''MAN''),''A extinguir'',''A extinguir'',''0'',''0'',(SELECT DD_POL_ID FROM '||V_ESQUEMA||'.DD_POL_POLITICAS WHERE DD_POL_CODIGO = ''2''),''0'',''0'',''PROD-1151'',SYSDATE)';
		EXECUTE IMMEDIATE V_MSQL;
	
		DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TPL_TIPO_POLITICA nuevos registros añadidos');
	
		COMMIT;
	END IF;


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
  	