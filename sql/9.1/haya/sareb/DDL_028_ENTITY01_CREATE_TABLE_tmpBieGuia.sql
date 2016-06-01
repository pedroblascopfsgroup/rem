--/*
--#########################################
--## AUTOR=David González
--## FECHA_CREACION=20150107
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=BKREC-1689
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tabla TMPBIEGUIA 
--##			para la actualización de fondos.
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
V_SENTENCIA VARCHAR2(1600 CHAR);
V_NUM NUMBER(1,0);

BEGIN

		DBMS_OUTPUT.PUT_LINE('[INICIO] Comprobando la existencia de la tabla ...');
	
		V_SENTENCIA := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMPBIEGUIA'' AND OWNER = '''||V_ESQUEMA||'''';
	
	EXECUTE IMMEDIATE V_SENTENCIA INTO V_NUM;
	
	IF V_NUM > 0 THEN
		
		DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ya existe.');
		
	ELSE
	
		DBMS_OUTPUT.PUT_LINE('[INFO] La tabla no existe, creando tabla '||V_ESQUEMA||'.TMPBIEGUIA ...');
	
		V_SENTENCIA := 'CREATE TABLE '||V_ESQUEMA||'.TMPBIEGUIA
					   (BIE_ID NUMBER(16,0) NOT NULL ENABLE, 
						DD_TFO_ID NUMBER(16,0)
					   )
					   '
					   ;
					
	EXECUTE IMMEDIATE V_SENTENCIA;
	
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_ESQUEMA||'.TMPBIEGUIA creada.');
	
	END IF;
	
EXCEPTION
	
	WHEN OTHERS THEN
     
		DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecucion: '||TO_CHAR(SQLCODE));
		DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
		DBMS_OUTPUT.put_line(SQLERRM);

	ROLLBACK;
	RAISE;          

END;
/

EXIT;
