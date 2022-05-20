--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220513
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-11670
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas LOG_SUBTIPOS_ACTIVO
--##
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial - [REMVIP-11670]- Alejandra García
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA VARCHAR2(20 CHAR) := '#ESQUEMA#';
V_TABLA VARCHAR2(40 CHAR) := 'LOG_SUBTIPOS_ACTIVO';
V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.

BEGIN
	

	/***** LOG_SUBTIPOS_ACTIVO *****/
	
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
                                        ACT_ID_N NUMBER,
                                        ACT_ID_O NUMBER,
                                        DD_CRA_ID_N NUMBER,
                                        DD_CRA_ID_O NUMBER,
                                        DD_TPA_ID_N NUMBER,
                                        DD_TPA_ID_O NUMBER,
                                        DD_SAC_ID_N NUMBER,
                                        DD_SAC_ID_O NUMBER,
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
                                        FECHABORRAR_O DATE
                                )';

	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||' CREADA'); 

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
