   --/*
--######################################### 
--## AUTOR=SIMEON SHOPOV
--## FECHA_CREACION=20171212
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-3413
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla ACT_ACTIVO_BNK
--##                    
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

TABLE_COUNT NUMBER(1,0) := 0;
V_ESQUEMA_1 VARCHAR2(20 CHAR) := 'REM01';
V_TABLESPACE_IDX VARCHAR2(30 CHAR) := '#TABLESPACE_INDEX#';
V_TABLA VARCHAR2(40 CHAR) := 'ACT_ACTIVO_BNK';

BEGIN

        SELECT COUNT(1) INTO TABLE_COUNT FROM ALL_TABLES WHERE TABLE_NAME = ''||V_TABLA||'' AND OWNER= ''||V_ESQUEMA_1||'';

        IF TABLE_COUNT > 0 THEN

                DBMS_OUTPUT.PUT_LINE('[INFO] TABLA '||V_ESQUEMA_1||'.'||V_TABLA||' YA EXISTENTE.');

        ELSE 
        
            EXECUTE IMMEDIATE '
		CREATE TABLE '||V_ESQUEMA_1||'.ACT_ACTIVO_BNK 
	 	 (
	 	 ACT_ID NUMBER(16,0) NOT NULL, 
		 ACB_COTSIN VARCHAR2(4 CHAR),
	    	 ACB_COREAE NUMBER(5,0),
	    	 ACB_COREAE_TEXTO VARCHAR2(30 CHAR),
	    	 VERSION NUMBER(38,0) DEFAULT 0 NOT NULL ENABLE, 
		 USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL ENABLE, 
		 FECHACREAR TIMESTAMP (6) NOT NULL ENABLE, 
		 USUARIOMODIFICAR VARCHAR2(50 CHAR), 
		 FECHAMODIFICAR TIMESTAMP (6), 
		 USUARIOBORRAR VARCHAR2(50 CHAR), 
		 FECHABORRAR TIMESTAMP (6), 
		 BORRADO NUMBER(1,0) DEFAULT 0, 
		 CONSTRAINT ACT_ID_PK PRIMARY KEY (ACT_ID),
		 CONSTRAINT ACT_ID_FK FOREIGN KEY (ACT_ID)
		 REFERENCES '||V_ESQUEMA_1||'.ACT_ACTIVO (ACT_ID) ON DELETE SET NULL
		 )'
		;
             
        EXECUTE IMMEDIATE 'COMMENT ON TABLE '||V_ESQUEMA_1||'.'||V_TABLA||'  IS ''Tabla auxiliar para el tipo y subtipo de activo.''';

        DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA_1||'.'||V_TABLA||' CREADA');  
        
        
        END IF;

        

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

