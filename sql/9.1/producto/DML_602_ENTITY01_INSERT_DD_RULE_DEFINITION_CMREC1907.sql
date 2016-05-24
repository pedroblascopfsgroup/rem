--/*
--##########################################
--## AUTOR=BRUNO ANGLES
--## FECHA_CREACION=20160125
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1.0-cj-rc36.1-CMREC-1907s
--## INCIDENCIA_LINK=CMREC-1907
--## PRODUCTO=SI
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Añadir dos variables nuevas de arquetipacion
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_COUNT NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_STRING VARCHAR2(10); -- Vble. para validar la existencia de si el campo es nulo
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage

    BEGIN


	V_SQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RULE_DEFINITION WHERE UPPER(RD_COLUMN) = ''PER_RIESGO_TOTAL''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro en la tabla');
	ELSE
		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.DD_RULE_DEFINITION (RD_ID,RD_TITLE,RD_COLUMN,RD_TYPE,RD_VALUE_FORMAT,RD_BO_VALUES,RD_TAB,USUARIOCREAR,FECHACREAR,BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_RULE_DEFINITION.nextval,''Riesgo Total de la Persona - Compara1Valor (Carga)'',''per_riesgo_total'',''compare1'',''number'',null,''Riesgo'',''DD'',sysdate,0)';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en la tabla');

		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.DD_RULE_DEFINITION (RD_ID,RD_TITLE,RD_COLUMN,RD_TYPE,RD_VALUE_FORMAT,RD_BO_VALUES,RD_TAB,USUARIOCREAR,FECHACREAR,BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_RULE_DEFINITION.nextval,''Riesgo Total de la Persona - Compara2Valores (Carga)'',''per_riesgo_total'',''compare2'',''number'',null,''Riesgo'',''DD'',sysdate,0)';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en la tabla');
	END IF;


	V_SQL:= 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.DD_RULE_DEFINITION WHERE UPPER(RD_COLUMN) = ''GCL_NOMBRE''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe el registro en la tabla');
	ELSE
		V_MSQL:= 'INSERT INTO '||V_ESQUEMA||'.DD_RULE_DEFINITION (RD_ID,RD_TITLE,RD_COLUMN,RD_TYPE,RD_VALUE_FORMAT,RD_BO_VALUES,RD_TAB,USUARIOCREAR,FECHACREAR,BORRADO) VALUES ('||V_ESQUEMA||'.S_DD_RULE_DEFINITION.nextval,''Grupo Economico de la Persona - Compara1Valor (Carga)'',''gcl_nombre'',''compare1'',''text'',null,''Persona'',''DD'',sysdate,0)';
		DBMS_OUTPUT.PUT_LINE(V_MSQL);
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Registro insertado en la tabla');
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
