--/*
--##########################################
--## AUTOR=BRUNO ANGLES
--## FECHA_CREACION=20160125
--## ARTEFACTO=
--## VERSION_ARTEFACTO=
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    
    V_ESQUEMA_MIN VARCHAR2(25 CHAR):= '#ESQUEMA_MINI#'; -- Configuracion Esquema minirec
    V_ESQUEMA_DWH VARCHAR2(25 CHAR):= '#ESQUEMA_DWH#'; -- Configuracion Esquema recovery_bankia_dwh
    V_ESQUEMA_STG VARCHAR2(25 CHAR):= '#ESQUEMA_STG#'; -- Configuracion Esquema recovery_bankia_datastage

    BEGIN
	    
	 -- Añadir camo DATA_RULE_ENGINE.PER_RIESGO_TOTAL
    DBMS_OUTPUT.PUT_LINE('[INFO] Campo ' || V_ESQUEMA || '.DATA_RULE_ENGINE.PER_RIESGO_TOTAL ...');
	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = ''PER_RIESGO_TOTAL'' AND TABLE_NAME = ''DATA_RULE_ENGINE''';
		  
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] El campo ya existe en la tabla');
	ELSE 
		V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.DATA_RULE_ENGINE ADD PER_RIESGO_TOTAL NUMBER(14,2)';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.DATA_RULE_ENGINE.PER_RIESGO_TOTAL... Campo añadido.');
	END IF;

	 -- Añadir camo DATA_RULE_ENGINE.GCL_NOMBRE
    DBMS_OUTPUT.PUT_LINE('[INFO] Campo ' || V_ESQUEMA || '.DATA_RULE_ENGINE.GCL_NOMBRE ...');
	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = ''GCL_NOMBRE'' AND TABLE_NAME = ''DATA_RULE_ENGINE''';
		  
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
	IF V_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] El campo ya existe en la tabla');
	ELSE 
		V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.DATA_RULE_ENGINE ADD GCL_NOMBRE NUMBER(14,2)';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla ' || V_ESQUEMA || '.DATA_RULE_ENGINE.GCL_NOMBRE... Campo añadido.');
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
