--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20160120
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=BKREC-1766
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla BANK01.TMP_ALTA_BPM_INSTANCES
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

V_ESQUEMA VARCHAR2(10 CHAR) := '#ESQUEMA#';
V_TABLA VARCHAR2(40 CHAR);
V_SENTENCIA VARCHAR2(1600 CHAR);
V_NUM NUMBER(9,0);

BEGIN


	DBMS_OUTPUT.PUT_LINE('[INICIO] Comienza el proceso de creación de tablas...');
		
	V_TABLA := 'TMP_ALTA_BPM_INSTANCES';
	
	V_SENTENCIA := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	
	EXECUTE IMMEDIATE V_SENTENCIA INTO V_NUM;
	
	IF V_NUM > 0 THEN
		
		DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ya existe');
		
	ELSE
	
	V_SENTENCIA := 'CREATE GLOBAL TEMPORARY TABLE '||V_ESQUEMA||'.'||V_TABLA||'
				   (PRC_ID NUMBER(16, 0) NOT NULL 
					, DEF_ID NUMBER(16, 0) NOT NULL 
					, NODE_ID NUMBER(16, 0) NOT NULL 
					, TAP_CODIGO VARCHAR2(100 CHAR) NOT NULL 
					, TEX_ID NUMBER(16, 0) NOT NULL 
					, FORK_NODE NUMBER(16, 0) 
					, INST_ID NUMBER(16, 0) NOT NULL 
					, TOKEN_PADRE_ID NUMBER(16, 0) 
					, MODULE_PADRE_ID NUMBER(16, 0) 
					, VMAP_PADRE_ID NUMBER(16, 0) 
					, TOKEN_ID NUMBER(16, 0) 
					, MODULE_ID NUMBER(16, 0) 
					, VMAP_ID NUMBER(16, 0)
				   )
				   '
				   ;
					
	EXECUTE IMMEDIATE V_SENTENCIA;
	
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla creada');
	
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('[FIN] Proceso de creación de tablas finalizado');

END;
/

EXIT;
