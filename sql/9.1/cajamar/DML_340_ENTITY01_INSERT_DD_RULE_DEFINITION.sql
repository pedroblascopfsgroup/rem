--/*
--##########################################
--## AUTOR=Carlos Perez
--## FECHA_CREACION=20151214
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1.0-cj-rc29.1
--## INCIDENCIA_LINK=-
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
	
	DBMS_OUTPUT.PUT_LINE('******** FUN_PEF ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_RULE_DEFINITION... Comprobaciones previas'); 

	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_RULE_DEFINITION WHERE RD_BO_VALUES = ''DDEstadoInternoEntidad'' AND RD_TAB = ''Contrato''';
	--DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Existe el registro en la tabla '||V_ESQUEMA||'.DD_RULE_DEFINITION.');
	ELSE
    	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_BO_VALUES, RD_TAB, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_RULE_DEFINITION.NEXTVAL, ''Estado interno CAJAMAR'', ''dd_eic_id'',''dictionary'', ''number'', ''DDEstadoInternoEntidad'',''Contrato'',''CPI'',SYSDATE,NULL,NULL,NULL,NULL,0)';
    	--DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.DD_RULE_DEFINITION');
	END IF;
	

	
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_RULE_DEFINITION WHERE RD_BO_VALUES = ''DDCondicionesRemuneracion'' AND RD_TAB = ''Contrato''';
	--DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Existe el registro en la tabla '||V_ESQUEMA||'.DD_RULE_DEFINITION.');
	ELSE
    	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_BO_VALUES, RD_TAB, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_RULE_DEFINITION.NEXTVAL, ''Motivo Gestión Especial'', ''dd_cre_id'',''dictionary'', ''number'', ''DDCondicionesRemuneracion'',''Contrato'',''CPI'',SYSDATE,NULL,NULL,NULL,NULL,0)';
    	--DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.DD_RULE_DEFINITION');
	END IF;

	

	
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_RULE_DEFINITION WHERE RD_BO_VALUES = ''DDTipoGrupoCliente'' AND RD_TAB = ''Persona''';
	--DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		DBMS_OUTPUT.PUT_LINE('[INFO] Existe el registro en la tabla '||V_ESQUEMA||'.DD_RULE_DEFINITION.');
	ELSE
    	V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.DD_RULE_DEFINITION (RD_ID, RD_TITLE, RD_COLUMN, RD_TYPE, RD_VALUE_FORMAT, RD_BO_VALUES, RD_TAB, USUARIOCREAR, FECHACREAR, USUARIOMODIFICAR, FECHAMODIFICAR, USUARIOBORRAR, FECHABORRAR, BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_RULE_DEFINITION.NEXTVAL, ''Tipo Grupo Económico'', ''dd_tgl_id'',''dictionary'', ''number'', ''DDTipoGrupoCliente'',''Persona'',''CPI'',SYSDATE,NULL,NULL,NULL,NULL,0)';
    	--DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.DD_RULE_DEFINITION');
	END IF;
	
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_RULE_DEFINITION WHERE RD_COLUMN = ''pto_intervalo'' AND RD_TAB = ''Persona''';
	--DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_RULE_DEFINITION SET RD_VALUE_FORMAT = ''text'',USUARIOMODIFICAR=''CPI'',FECHAMODIFICAR=SYSDATE WHERE RD_COLUMN = ''pto_intervalo''';    	
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.DD_RULE_DEFINITION');
	END IF;
	
	V_SQL := 'SELECT COUNT(*) FROM '||V_ESQUEMA||'.DD_RULE_DEFINITION WHERE RD_COLUMN = ''per_empleado'' AND RD_TAB = ''Persona''';
	--DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    IF V_NUM_TABLAS > 0 THEN	  
		V_MSQL := 'UPDATE '||V_ESQUEMA||'.DD_RULE_DEFINITION SET RD_VALUE_FORMAT = ''number'', RD_TYPE=''dictionary'', RD_BO_VALUES=''DDSiNo'', USUARIOMODIFICAR=''CPI'', FECHAMODIFICAR=SYSDATE WHERE RD_COLUMN = ''per_empleado''';    	
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro actualizado en '||V_ESQUEMA||'.DD_RULE_DEFINITION');
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
