--/*
--######################################### 
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20181127
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-2677
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla temporal para trazar tareas trabajos
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial SOG
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := '#TABLESPACE_INDEX#';
V_TABLA VARCHAR2(40 CHAR) := 'APR_AUX_TAREAS_TRABAJOS';
V_SQL VARCHAR(32000 CHAR);

BEGIN

SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA||'';

IF TABLE_COUNT > 0 THEN

    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. SE PROCEDE A BORRAR Y CREAR DE NUEVO.');

    EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
    
END IF;

	V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'  
				(
					  TBJ_ID NUMBER(16, 0) NOT NULL 
					, TRA_ID NUMBER(16, 0) NOT NULL
					, TAR_ID NUMBER(16, 0) NOT NULL
				)';

	EXECUTE IMMEDIATE V_SQL;

DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' CREADA');  


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
