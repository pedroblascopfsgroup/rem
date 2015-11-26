--/*
--##########################################
--## AUTOR=Alberto B
--## FECHA_CREACION=20151126
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc23
--## INCIDENCIA_LINK=CMREC-1096
--## PRODUCTO=NO
--## Finalidad: DML
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
BEGIN
	DBMS_OUTPUT.PUT_LINE('******** DD_PAS_PROPIEDAD_ASUNTO ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_PAS_PROPIEDAD_ASUNTO... Comprobaciones previas'); 

    V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PAS_PROPIEDAD_ASUNTO WHERE DD_PAS_CODIGO = ''SAREB'' AND BORRADO = 1';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 1 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] El registro ya ha sido borrado en la tabla '||V_ESQUEMA||'.DD_PAS_PROPIEDAD_ASUNTO.');
	ELSE
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_PAS_PROPIEDAD_ASUNTO SET BORRADO = 1, USUARIOBORRAR = ''CMREC-1096'', FECHABORRAR= SYSDATE WHERE DD_PAS_CODIGO = ''SAREB''';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.DD_PAS_PROPIEDAD_ASUNTO');
		
	END IF;
	
	V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_PAS_PROPIEDAD_ASUNTO WHERE DD_PAS_CODIGO = ''HAYA''';
    DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 1 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] El registro ya existe en la tabla '||V_ESQUEMA||'.DD_PAS_PROPIEDAD_ASUNTO.');
	ELSE
		V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_PAS_PROPIEDAD_ASUNTO (DD_PAS_ID, DD_PAS_CODIGO, DD_PAS_DESCRIPCION, DD_PAS_DESCRIPCION_LARGA, VERSION, USUARIOCREAR, FECHACREAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_PAS_PROPIEDAD_ASUNTO.NEXTVAL, ''HAYA'',''HAYA'',''HAYA'', 0, ''CMREC-1096'', SYSDATE, 0)';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en '||V_ESQUEMA||'.DD_PAS_PROPIEDAD_ASUNTO');
		
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
