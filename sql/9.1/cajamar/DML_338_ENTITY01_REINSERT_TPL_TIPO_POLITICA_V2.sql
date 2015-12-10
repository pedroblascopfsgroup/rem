--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=09-12-2015
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-1493
--## PRODUCTO=NO
--## Finalidad: DML para igualar las políticas de recovery con las de cajamar, y marcar la tendencia enviada, según segundo acuerdo
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
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
    
    V_POLITICA DD_POL_POLITICAS%ROWTYPE;
    V_TEN_ASCENDENTE_ID NUMBER(16);
    V_TEN_MANTENER_ID NUMBER(16);
    V_TEN_DESCENDENTE_ID NUMBER(16);
    
    V_ID_TPL NUMBER(16);
    V_ID_DD_POL NUMBER(16);
    
BEGIN
	DBMS_OUTPUT.PUT_LINE('******** OBTENER IDs TENDENCIAS POR CODIGO ********');
	V_MSQL := 'SELECT TEN_ID FROM '||V_ESQUEMA||'.TEN_TENDENCIA WHERE TEN_CODIGO = ''ASC'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_TEN_ASCENDENTE_ID;
	
	V_MSQL := 'SELECT TEN_ID FROM '||V_ESQUEMA||'.TEN_TENDENCIA WHERE TEN_CODIGO = ''MAN'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_TEN_MANTENER_ID;
	
	V_MSQL := 'SELECT TEN_ID FROM '||V_ESQUEMA||'.TEN_TENDENCIA WHERE TEN_CODIGO = ''DES'' ';
	EXECUTE IMMEDIATE V_MSQL INTO V_TEN_DESCENDENTE_ID;	
	
	DBMS_OUTPUT.PUT_LINE('******** BORRADO LOGICO DE DD_POL_POLITICAS ********');
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_POL_POLITICAS SET BORRADO = 1, USUARIOBORRAR = ''DML'', FECHABORRAR =  SYSDATE WHERE BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrados todos los tipos de política del cliente.');	
	
	DBMS_OUTPUT.PUT_LINE('******** BORRADO LOGICO DE TPL_TIPO_POLITICA ********');
	V_MSQL := 'UPDATE '||V_ESQUEMA||'.TPL_TIPO_POLITICA SET BORRADO = 1, USUARIOBORRAR = ''DML'', FECHABORRAR =  SYSDATE WHERE BORRADO = 0';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Borrados todos los tipos de política.');

	DBMS_OUTPUT.PUT_LINE('******** COPIAR EN TPL_TIPO_POLITICA Y EN DD_POL_POLITICAS ********');
	
	/**************************************** Expansiva ************************************/ 
	DBMS_OUTPUT.PUT_LINE('[INFO] **************************************** Expansiva');
	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_POL_POLITICAS.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_DD_POL;
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_POL_POLITICAS (DD_POL_ID, DD_POL_CODIGO, DD_POL_DESCRIPCION, DD_POL_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
						VALUES ('||V_ID_DD_POL||',''POL'||V_ID_DD_POL||''',''Expansiva'',''Expansiva'',''DML'',SYSDATE)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Expansiva insertada en DD_POL_POLITICAS');
	
	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_TPL;	
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA  (TPL_ID, TPL_CODIGO, TEN_ID, TPL_DESCRIPCION, TPL_DESCRIPCION_LARGA, DD_POL_ID, USUARIOCREAR, FECHACREAR) 
	  					VALUES ('||V_ID_TPL||', ''TPL'||V_ID_TPL||''', '||V_TEN_ASCENDENTE_ID||',''Expansiva'',''Expansiva'','||V_ID_DD_POL||',''DML'',SYSDATE)';
	EXECUTE IMMEDIATE V_MSQL;	  					
	DBMS_OUTPUT.PUT_LINE('[INFO] Expansiva insertada en TPL_TIPO_POLITICA');
	
	/**************************************** Adecuado Nivel de Riesgos ************************************/ 
	DBMS_OUTPUT.PUT_LINE('[INFO] **************************************** Adecuado Nivel de Riesgos');
	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_POL_POLITICAS.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_DD_POL;
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_POL_POLITICAS (DD_POL_ID, DD_POL_CODIGO, DD_POL_DESCRIPCION, DD_POL_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
						VALUES ('||V_ID_DD_POL||',''POL'||V_ID_DD_POL||''',''Adecuado Nivel de Riesgos'',''Adecuado Nivel de Riesgos'',''DML'',SYSDATE)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Adecuado Nivel de Riesgos insertada en DD_POL_POLITICAS');
	
	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_TPL;	
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA  (TPL_ID, TPL_CODIGO, TEN_ID, TPL_DESCRIPCION, TPL_DESCRIPCION_LARGA, DD_POL_ID, USUARIOCREAR, FECHACREAR) 
	  					VALUES ('||V_ID_TPL||', ''TPL'||V_ID_TPL||''', '||V_TEN_MANTENER_ID||',''Adecuado Nivel de Riesgos'',''Adecuado Nivel de Riesgos'','||V_ID_DD_POL||',''DML'',SYSDATE)';
	EXECUTE IMMEDIATE V_MSQL;	  					
	DBMS_OUTPUT.PUT_LINE('[INFO] Adecuado Nivel de Riesgos insertada en TPL_TIPO_POLITICA');	
	
	/**************************************** Seguir Evolución de Riesgos ************************************/ 
	DBMS_OUTPUT.PUT_LINE('[INFO] **************************************** Seguir Evolución de Riesgos');
	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_POL_POLITICAS.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_DD_POL;
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_POL_POLITICAS (DD_POL_ID, DD_POL_CODIGO, DD_POL_DESCRIPCION, DD_POL_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
						VALUES ('||V_ID_DD_POL||',''POL'||V_ID_DD_POL||''',''Seguir Evolución de Riesgos'',''Seguir Evolución de Riesgos'',''DML'',SYSDATE)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Adecuado Nivel de Riesgos insertada en DD_POL_POLITICAS');
	
	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_TPL;	
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA  (TPL_ID, TPL_CODIGO, TEN_ID, TPL_DESCRIPCION, TPL_DESCRIPCION_LARGA, DD_POL_ID, USUARIOCREAR, FECHACREAR) 
	  					VALUES ('||V_ID_TPL||', ''TPL'||V_ID_TPL||''', '||V_TEN_MANTENER_ID||',''Seguir Evolución de Riesgos'',''Seguir Evolución de Riesgos'','||V_ID_DD_POL||',''DML'',SYSDATE)';
	EXECUTE IMMEDIATE V_MSQL;	  					
	DBMS_OUTPUT.PUT_LINE('[INFO] Seguir Evolución de Riesgos insertada en TPL_TIPO_POLITICA');	
	
	/**************************************** Afianzar Nivel de Riesgos ************************************/ 
	DBMS_OUTPUT.PUT_LINE('[INFO] **************************************** Afianzar Nivel de Riesgos');
	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_POL_POLITICAS.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_DD_POL;
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_POL_POLITICAS (DD_POL_ID, DD_POL_CODIGO, DD_POL_DESCRIPCION, DD_POL_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
						VALUES ('||V_ID_DD_POL||',''POL'||V_ID_DD_POL||''',''Afianzar Nivel de Riesgos'',''Afianzar Nivel de Riesgos'',''DML'',SYSDATE)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Adecuado Nivel de Riesgos insertada en DD_POL_POLITICAS');
	
	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_TPL;	
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA  (TPL_ID, TPL_CODIGO, TEN_ID, TPL_DESCRIPCION, TPL_DESCRIPCION_LARGA, DD_POL_ID, USUARIOCREAR, FECHACREAR) 
	  					VALUES ('||V_ID_TPL||', ''TPL'||V_ID_TPL||''', '||V_TEN_MANTENER_ID||',''Afianzar Nivel de Riesgos'',''Afianzar Nivel de Riesgos'','||V_ID_DD_POL||',''DML'',SYSDATE)';
	EXECUTE IMMEDIATE V_MSQL;	  					
	DBMS_OUTPUT.PUT_LINE('[INFO] Afianzar Nivel de Riesgos insertada en TPL_TIPO_POLITICA');
	
	/**************************************** Reducir Nivel de Riesgos ************************************/ 
	DBMS_OUTPUT.PUT_LINE('[INFO] **************************************** Reducir Nivel de Riesgos');
	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_POL_POLITICAS.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_DD_POL;
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_POL_POLITICAS (DD_POL_ID, DD_POL_CODIGO, DD_POL_DESCRIPCION, DD_POL_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
						VALUES ('||V_ID_DD_POL||',''POL'||V_ID_DD_POL||''',''Reducir Nivel de Riesgos'',''Reducir Nivel de Riesgos'',''DML'',SYSDATE)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Adecuado Nivel de Riesgos insertada en DD_POL_POLITICAS');
	
	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_TPL;	
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA  (TPL_ID, TPL_CODIGO, TEN_ID, TPL_DESCRIPCION, TPL_DESCRIPCION_LARGA, DD_POL_ID, USUARIOCREAR, FECHACREAR) 
	  					VALUES ('||V_ID_TPL||', ''TPL'||V_ID_TPL||''', '||V_TEN_DESCENDENTE_ID||',''Reducir Nivel de Riesgos'',''Reducir Nivel de Riesgos'','||V_ID_DD_POL||',''DML'',SYSDATE)';
	EXECUTE IMMEDIATE V_MSQL;	  					
	DBMS_OUTPUT.PUT_LINE('[INFO] Reducir Nivel de Riesgos insertada en TPL_TIPO_POLITICA');	
	
	/**************************************** Extinguir Nivel de Riesgos ************************************/ 
	DBMS_OUTPUT.PUT_LINE('[INFO] **************************************** Extinguir Nivel de Riesgos');
	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_DD_POL_POLITICAS.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_DD_POL;
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_POL_POLITICAS (DD_POL_ID, DD_POL_CODIGO, DD_POL_DESCRIPCION, DD_POL_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR)
						VALUES ('||V_ID_DD_POL||',''POL'||V_ID_DD_POL||''',''Extinguir Nivel de Riesgos'',''Extinguir Nivel de Riesgos'',''DML'',SYSDATE)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] Adecuado Nivel de Riesgos insertada en DD_POL_POLITICAS');
	
	V_MSQL := 'SELECT '||V_ESQUEMA||'.S_TPL_TIPO_POLITICA.NEXTVAL FROM DUAL';
	EXECUTE IMMEDIATE V_MSQL INTO V_ID_TPL;	
	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.TPL_TIPO_POLITICA  (TPL_ID, TPL_CODIGO, TEN_ID, TPL_DESCRIPCION, TPL_DESCRIPCION_LARGA, DD_POL_ID, USUARIOCREAR, FECHACREAR) 
	  					VALUES ('||V_ID_TPL||', ''TPL'||V_ID_TPL||''', '||V_TEN_DESCENDENTE_ID||',''Extinguir Nivel de Riesgos'',''Extinguir Nivel de Riesgos'','||V_ID_DD_POL||',''DML'',SYSDATE)';
	EXECUTE IMMEDIATE V_MSQL;	  					
	DBMS_OUTPUT.PUT_LINE('[INFO] Extinguir Nivel de Riesgos insertada en TPL_TIPO_POLITICA');		
	
	
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
