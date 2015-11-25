--/*
--##########################################
--## AUTOR=Javier Ruiz
--## FECHA_CREACION=20151118
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.3
--## INCIDENCIA_LINK=PRODUCTO-461
--## PRODUCTO=NO
--## Finalidad: DML Insertar valores en diccionario riesgo operacional
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
    
    V_CODIGO VARCHAR2(2 CHAR); -- Vble. auxiliar para codigo diccionario
BEGIN
	DBMS_OUTPUT.PUT_LINE('******** DD_RIO_RIESGO_OPERACIONAL ********'); 

	V_CODIGO := '00';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL WHERE DD_RIO_CODIGO = '''||V_CODIGO||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con codigo:'''||V_CODIGO||''' en la tabla '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL (DD_RIO_ID, DD_RIO_CODIGO, DD_RIO_DESCRIPCION, DD_RIO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) ' ||
  				  'VALUES  (S_DD_RIO_RIESGO_OPERACIONAL.NEXTVAL, '''||V_CODIGO||''', ''Sin riesgo operacional/no procede'', ''Sin riesgo operacional/no procede'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro con codigo:'''||V_CODIGO||''' insertado en '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	END IF;
	
	V_CODIGO := '01';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL WHERE DD_RIO_CODIGO = '''||V_CODIGO||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con codigo:'''||V_CODIGO||''' en la tabla '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL (DD_RIO_ID, DD_RIO_CODIGO, DD_RIO_DESCRIPCION, DD_RIO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) ' ||
  				  'VALUES  (S_DD_RIO_RIESGO_OPERACIONAL.NEXTVAL, '''||V_CODIGO||''', ''Fallos documentales que impidan la realización del cobro'', ''Fallos documentales que impidan la realización del cobro'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro con codigo:'''||V_CODIGO||''' insertado en '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	END IF;
	
	V_CODIGO := '02';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL WHERE DD_RIO_CODIGO = '''||V_CODIGO||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con codigo:'''||V_CODIGO||''' en la tabla '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL (DD_RIO_ID, DD_RIO_CODIGO, DD_RIO_DESCRIPCION, DD_RIO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) ' ||
  				  'VALUES  (S_DD_RIO_RIESGO_OPERACIONAL.NEXTVAL, '''||V_CODIGO||''', ''Abono por duplicado de facturas pagadas a procuradores'', ''Abono por duplicado de facturas pagadas a procuradores'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro con codigo:'''||V_CODIGO||''' insertado en '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	END IF;	
	
	V_CODIGO := '03';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL WHERE DD_RIO_CODIGO = '''||V_CODIGO||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con codigo:'''||V_CODIGO||''' en la tabla '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL (DD_RIO_ID, DD_RIO_CODIGO, DD_RIO_DESCRIPCION, DD_RIO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) ' ||
  				  'VALUES  (S_DD_RIO_RIESGO_OPERACIONAL.NEXTVAL, '''||V_CODIGO||''', ''Contratos de operaciones sin firmar'', ''Contratos de operaciones sin firmar'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro con codigo:'''||V_CODIGO||''' insertado en '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	END IF;
	
	V_CODIGO := '04';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL WHERE DD_RIO_CODIGO = '''||V_CODIGO||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con codigo:'''||V_CODIGO||''' en la tabla '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL (DD_RIO_ID, DD_RIO_CODIGO, DD_RIO_DESCRIPCION, DD_RIO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) ' ||
  				  'VALUES  (S_DD_RIO_RIESGO_OPERACIONAL.NEXTVAL, '''||V_CODIGO||''', ''Error en datos en modelo de calificación o formalización de operación'', ''Error en datos en modelo de calificación o formalización de operación'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro con codigo:'''||V_CODIGO||''' insertado en '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	END IF;	
	
	V_CODIGO := '05';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL WHERE DD_RIO_CODIGO = '''||V_CODIGO||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con codigo:'''||V_CODIGO||''' en la tabla '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL (DD_RIO_ID, DD_RIO_CODIGO, DD_RIO_DESCRIPCION, DD_RIO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) ' ||
  				  'VALUES  (S_DD_RIO_RIESGO_OPERACIONAL.NEXTVAL, '''||V_CODIGO||''', ''Incumplimiento de los procesos para concesión operaciones'', ''Incumplimiento de los procesos para concesión operaciones'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro con codigo:'''||V_CODIGO||''' insertado en '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	END IF;
	
	V_CODIGO := '06';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL WHERE DD_RIO_CODIGO = '''||V_CODIGO||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con codigo:'''||V_CODIGO||''' en la tabla '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL (DD_RIO_ID, DD_RIO_CODIGO, DD_RIO_DESCRIPCION, DD_RIO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) ' ||
  				  'VALUES  (S_DD_RIO_RIESGO_OPERACIONAL.NEXTVAL, '''||V_CODIGO||''', ''Manipulación interna de datos para concesión de operación'', ''Manipulación interna de datos para concesión de operación'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro con codigo:'''||V_CODIGO||''' insertado en '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	END IF;	
	
	V_CODIGO := '07';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL WHERE DD_RIO_CODIGO = '''||V_CODIGO||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con codigo:'''||V_CODIGO||''' en la tabla '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL (DD_RIO_ID, DD_RIO_CODIGO, DD_RIO_DESCRIPCION, DD_RIO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) ' ||
  				  'VALUES  (S_DD_RIO_RIESGO_OPERACIONAL.NEXTVAL, '''||V_CODIGO||''', ''Pérdida o destrucción de documento de expediente que impida recuperar deuda'', ''Pérdida o destrucción de documento de expediente que impida recuperar deuda'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro con codigo:'''||V_CODIGO||''' insertado en '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	END IF;
	
	V_CODIGO := '08';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL WHERE DD_RIO_CODIGO = '''||V_CODIGO||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con codigo:'''||V_CODIGO||''' en la tabla '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL (DD_RIO_ID, DD_RIO_CODIGO, DD_RIO_DESCRIPCION, DD_RIO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) ' ||
  				  'VALUES  (S_DD_RIO_RIESGO_OPERACIONAL.NEXTVAL, '''||V_CODIGO||''', ''Actuación de proveedor o posible realización de fraudes a entidad'', ''Actuación de proveedor o posible realización de fraudes a entidad'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro con codigo:'''||V_CODIGO||''' insertado en '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	END IF;	
	
	V_CODIGO := '09';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL WHERE DD_RIO_CODIGO = '''||V_CODIGO||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con codigo:'''||V_CODIGO||''' en la tabla '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL (DD_RIO_ID, DD_RIO_CODIGO, DD_RIO_DESCRIPCION, DD_RIO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) ' ||
  				  'VALUES  (S_DD_RIO_RIESGO_OPERACIONAL.NEXTVAL, '''||V_CODIGO||''', ''Aportación de documentación falsa por cliente para concesión de operaciones'', ''Aportación de documentación falsa por cliente para concesión de operaciones'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro con codigo:'''||V_CODIGO||''' insertado en '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	END IF;	

	V_CODIGO := '10';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL WHERE DD_RIO_CODIGO = '''||V_CODIGO||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con codigo:'''||V_CODIGO||''' en la tabla '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL (DD_RIO_ID, DD_RIO_CODIGO, DD_RIO_DESCRIPCION, DD_RIO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) ' ||
  				  'VALUES  (S_DD_RIO_RIESGO_OPERACIONAL.NEXTVAL, '''||V_CODIGO||''', ''Fraude interno exceso en límites establecidos área riesgos'', ''Fraude interno exceso en límites establecidos área riesgos'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro con codigo:'''||V_CODIGO||''' insertado en '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	END IF;
	
	V_CODIGO := '11';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL WHERE DD_RIO_CODIGO = '''||V_CODIGO||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con codigo:'''||V_CODIGO||''' en la tabla '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL (DD_RIO_ID, DD_RIO_CODIGO, DD_RIO_DESCRIPCION, DD_RIO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) ' ||
  				  'VALUES  (S_DD_RIO_RIESGO_OPERACIONAL.NEXTVAL, '''||V_CODIGO||''', ''Fraude interno operaciones para falsear la morosidad'', ''Fraude interno operaciones para falsear la morosidad'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro con codigo:'''||V_CODIGO||''' insertado en '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	END IF;
	
	V_CODIGO := '12';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL WHERE DD_RIO_CODIGO = '''||V_CODIGO||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con codigo:'''||V_CODIGO||''' en la tabla '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL (DD_RIO_ID, DD_RIO_CODIGO, DD_RIO_DESCRIPCION, DD_RIO_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) ' ||
  				  'VALUES  (S_DD_RIO_RIESGO_OPERACIONAL.NEXTVAL, '''||V_CODIGO||''', ''Fraude externo'', ''Fraude externo'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro con codigo:'''||V_CODIGO||''' insertado en '||V_ESQUEMA||'.DD_RIO_RIESGO_OPERACIONAL.');
	END IF;	
	
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
