--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20220516
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-XXXXX
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas LOG_PVE_COD_UVEM
--##
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial - [REMVIP-XXXXX]- DAP
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_TABLA VARCHAR2(40 CHAR) := 'LOG_PVE_COD_UVEM';
V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN
	

	/***** LOG_PVE_COD_UVEM *****/
	
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER= '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO TABLE_COUNT;

	IF TABLE_COUNT > 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA||'.'||V_TABLA||' YA EXISTENTE. ');
    ELSE
        EXECUTE IMMEDIATE 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
                                    ( 
                                        FECHA DATE,
                                        USUARIO_SO VARCHAR2(40),
                                        NOMBRE_PC VARCHAR2(40),
                                        PVE_ID_N NUMBER,
                                        PVE_ID_O NUMBER,
                                        PVE_COD_UVEM_N NUMBER,
                                        PVE_COD_UVEM_O NUMBER,
                                        USUARIOCREAR_N VARCHAR2(250 CHAR),
                                        USUARIOCREAR_O VARCHAR2(250 CHAR),
                                        USUARIOMODIFICAR_N VARCHAR2(250 CHAR),
                                        USUARIOMODIFICAR_O VARCHAR2(250 CHAR),
                                        USUARIOBORRAR_N VARCHAR2(250 CHAR),
                                        USUARIOBORRAR_O VARCHAR2(250 CHAR),
                                        FECHACREAR_N DATE,
                                        FECHACREAR_O DATE,
                                        FECHAMODIFICAR_N DATE,
                                        FECHAMODIFICAR_O DATE,
                                        FECHABORRAR_N DATE,
                                        FECHABORRAR_O DATE,
                                        BORRADO_N NUMBER,
                                        BORRADO_O NUMBER
                                )';

	    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' CREADA'); 

        EXECUTE IMMEDIATE 'GRANT SELECT, UPDATE, DELETE TO '||V_ESQUEMA||'.'||V_TABLA||' ON PFSREM';

	END IF;

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
