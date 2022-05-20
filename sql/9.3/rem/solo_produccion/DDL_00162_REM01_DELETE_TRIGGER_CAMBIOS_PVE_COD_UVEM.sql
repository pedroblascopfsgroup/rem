--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20220516
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-XXXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Borrar trigger CAMBIOS_PVE_COD_UVEM
--##
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-XXXXX]- DAP
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_TRIGGER VARCHAR2(40 CHAR) := 'CAMBIOS_PVE_COD_UVEM';
V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN
	/***** CAMBIOS_PVE_COD_UVEM *****/
	
	V_SQL := 'SELECT COUNT(1) FROM ALL_TRIGGERS WHERE TRIGGER_NAME = '''||V_TRIGGER||''' AND OWNER= '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO TABLE_COUNT;

	IF TABLE_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] TRIGGER '||V_ESQUEMA||'.'||V_TRIGGER||' YA EXISTENTE. SE PROCEDE A BORRAR.');
		EXECUTE IMMEDIATE 'DROP TRIGGER '||V_ESQUEMA||'.'||V_TRIGGER||'';
    ELSE
		DBMS_OUTPUT.PUT_LINE('[INFO] TRIGGER '||V_ESQUEMA||'.'||V_TRIGGER||' NO EXISTE.');

	END IF;

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TRIGGER||' BORRADO');  
	

    COMMIT;
	
EXCEPTION

    WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion:'||TO_CHAR(SQLCODE));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------');
        DBMS_OUTPUT.put_line(SQLERRM);
        ROLLBACK;
        RAISE;
END;
/

EXIT;
