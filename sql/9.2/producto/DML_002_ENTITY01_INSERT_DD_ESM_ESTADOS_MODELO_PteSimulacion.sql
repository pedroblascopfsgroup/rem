--/*
--##########################################
--## AUTOR=salvador Gorrita
--## FECHA_CREACION=20160204
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.0-cj
--## INCIDENCIA_LINK=CMREC-2003
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
	DBMS_OUTPUT.PUT_LINE('******** DD_ESM_ESTADOS_MODELO ********'); 

	V_CODIGO := '5';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ESM_ESTADOS_MODELO WHERE DD_ESM_CODIGO = '''||V_CODIGO||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con codigo:'''||V_CODIGO||''' en la tabla '||V_ESQUEMA||'.DD_ESM_ESTADOS_MODELO.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ESM_ESTADOS_MODELO (DD_ESM_ID, DD_ESM_CODIGO, DD_ESM_DESCRIPCION, DD_ESM_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) ' ||
  				  'VALUES  ('||V_ESQUEMA||'.S_DD_ESM_ESTADOS_MODELO.NEXTVAL, '''||V_CODIGO||''', ''PDTE. SIMULACION'', ''Pendiente simulación'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro con codigo:'''||V_CODIGO||''' insertado en '||V_ESQUEMA||'.DD_ESM_ESTADOS_MODELO.');
	END IF;
	
	V_CODIGO := '6';
    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_ESM_ESTADOS_MODELO WHERE DD_ESM_CODIGO = '''||V_CODIGO||''' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existen el registro con codigo:'''||V_CODIGO||''' en la tabla '||V_ESQUEMA||'.DD_ESM_ESTADOS_MODELO.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_ESM_ESTADOS_MODELO (DD_ESM_ID, DD_ESM_CODIGO, DD_ESM_DESCRIPCION, DD_ESM_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR,BORRADO) ' ||
  				  'VALUES  ('||V_ESQUEMA||'.S_DD_ESM_ESTADOS_MODELO.NEXTVAL, '''||V_CODIGO||''', ''SIMULACION'', ''Simulación'', ''DML'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro con codigo:'''||V_CODIGO||''' insertado en '||V_ESQUEMA||'.DD_ESM_ESTADOS_MODELO.');
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
