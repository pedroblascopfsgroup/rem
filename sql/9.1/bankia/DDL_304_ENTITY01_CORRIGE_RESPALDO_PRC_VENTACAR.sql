--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20151203
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=BKREC-1494
--## PRODUCTO=NO
--## 
--## Finalidad: Borra tabla FIN_AUX_TMP_PCR_VENTACAR si existe, y crea la 
--##			buena; FIN_AUX_TMP_PRC_VENTACAR
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


----## CONFIRMAMOS LA EXISTENCIA DE FIN_AUX_TMP_PCR_VENTACAR, BORRAMOS. CONFIRMAMOS LA NO EXISTENCIA DE FIN_AUX_TMP_PRC_VENTACAR, CREAMOS.


	DBMS_OUTPUT.PUT_LINE('[INFO] Buscando tabla corrupta ...');
	
	V_TABLA := 'FIN_AUX_TMP_PCR_VENTACAR';
	
	V_SENTENCIA := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	
	EXECUTE IMMEDIATE V_SENTENCIA INTO V_NUM;
	
	IF V_NUM > 0 THEN
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Borrando la tabla '||V_TABLA||'');
		
		V_SENTENCIA := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' PURGE';
		
		EXECUTE IMMEDIATE V_SENTENCIA;
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO] La tabla '||V_TABLA||' no existe');
	
	END IF;
	
	V_TABLA := 'FIN_AUX_TMP_PRC_VENTACAR';
	
	V_SENTENCIA := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
	
	EXECUTE IMMEDIATE V_SENTENCIA INTO V_NUM;
	
	IF V_NUM > 0 THEN
	
		DBMS_OUTPUT.PUT_LINE('[INFO] La tabla '||V_TABLA||' ya existe');
	
	ELSE
	
		V_SENTENCIA := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
				   (PRC_ID NUMBER(16,0) NOT NULL ENABLE, 
					USUARIOMODIFICAR VARCHAR2(50 CHAR), 
					FECHAMODIFICAR TIMESTAMP (6), 
					DD_EPR_ID NUMBER(16,0)
				   )
				   '
				   ;
				   
		EXECUTE IMMEDIATE V_SENTENCIA;				
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TABLA||' creada');
				   
	END IF;
	
	COMMIT;
	
EXCEPTION
				WHEN OTHERS THEN

				  DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecuciÃ³n:'||TO_CHAR(SQLCODE));
				  DBMS_OUTPUT.put_line('-----------------------------------------------------------');
				  DBMS_OUTPUT.put_line(SQLERRM);

				  ROLLBACK;
				  RAISE;

END;
/
EXIT;

