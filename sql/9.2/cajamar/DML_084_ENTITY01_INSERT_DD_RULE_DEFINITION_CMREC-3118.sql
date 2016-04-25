--/*
--##########################################
--## AUTOR=Carlos Pérez
--## FECHA_CREACION=20160418
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2.2-cj-patch04
--## INCIDENCIA_LINK=CMREC-3118
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
    V_NUM_BORRADO NUMBER(16); -- Vble. para validar la existencia de una tabla. 
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
BEGIN
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_RULE_DEFINITION WHERE RD_COLUMN = ''DEUDA_IRREG_FALLIDOS'' AND RD_TAB = ''Riesgo''';
	--DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Existe el registro en la tabla '||V_ESQUEMA||'.DD_RULE_DEFINITION.');
	ELSE
    	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_BO_VALUES, RD_TAB, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_RULE_DEFINITION.NEXTVAL, ''Deuda irregular neta de fallidos, litigios y atípicos (1 valor)'', ''DEUDA_IRREG_FALLIDOS'',''compare1'', ''number'', null,''Riesgo'',''CMREC-3118'',SYSDATE,NULL,NULL,NULL,NULL,0)';
    	--DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro (DEUDA_IRREG_FALLIDOS 1 valor) actualizado en '||V_ESQUEMA||'.DD_RULE_DEFINITION');
		
    	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_BO_VALUES, RD_TAB, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_RULE_DEFINITION.NEXTVAL, ''Deuda irregular neta de fallidos, litigios y atípicos (2 valores)'', ''DEUDA_IRREG_FALLIDOS'',''compare2'', ''number'', null,''Riesgo'',''CMREC-3118'',SYSDATE,NULL,NULL,NULL,NULL,0)';
    	--DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro (DEUDA_IRREG_FALLIDOS 2 valores) actualizado en '||V_ESQUEMA||'.DD_RULE_DEFINITION');

	END IF;
	
	
	/******************************************/
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_RULE_DEFINITION WHERE RD_COLUMN = ''PROD_ATENCION_SOCIAL'' AND RD_TAB = ''Contrato''';
	--DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Existe el registro en la tabla '||V_ESQUEMA||'.DD_RULE_DEFINITION.');
	ELSE
    	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_BO_VALUES, RD_TAB, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_RULE_DEFINITION.NEXTVAL, ''Productos atención social'', ''PROD_ATENCION_SOCIAL'',''dictionary'', ''number'', ''DDSiNo'',''Contrato'',''CMREC-3118'',SYSDATE,NULL,NULL,NULL,NULL,0)';
    	--DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro (PROD_ATENCION_SOCIAL) actualizado en '||V_ESQUEMA||'.DD_RULE_DEFINITION');
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
