--/*
--##########################################
--## AUTOR=DAVID GONZÁLEZ
--## FECHA_CREACION=20151101
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=0.1
--## INCIDENCIA_LINK=BKREC-1335
--## PRODUCTO=NO
--## Finalidad: DDL
--##      
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##
--##        0.1 Versión inicial
--##########################################
--*/

--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

DECLARE

	V_SELECT VARCHAR2(4000 CHAR); -- SENTENCIA DE SELECT PARA CONSULTAR EXISTENCIA (ANTERIORMENTE V_SQL)
	V_SENTENCIA VARCHAR2(32000 CHAR); -- SENTENCIA A EJECUTAR (ANTERIORMENTE V_MSQL)
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA_MINIREC#'; -- CONFIGURACIÓN ESQUEMA
	V_TABLA VARCHAR2(30 CHAR):= 'RCV_GEST_LOG'; -- DECLARA LA TABLA
	V_SECUENCIA VARCHAR2(30 CHAR):= 'S_RCV_GEST_LOG'; -- DECLARA LA SECUENCIA
	V_NUM NUMBER(16); -- ALOJA EL RETORNO DE LA SENTENCIA SELECT

BEGIN
	
	-- BUSCA LA TABLA RCV_GEST_LOG EN MINIREC	

	 V_SELECT:= 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
	 
	 EXECUTE IMMEDIATE V_SELECT INTO V_NUM;
	 DBMS_OUTPUT.PUT_LINE('[INFO] Verificando la existencia de la tabla....');
	 
	 IF V_NUM > 0 THEN
	 
		-- LA TABLA RCV_GEST_LOG YA EXISTE EN MINIREC
	 
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TABLA||' ya existente en '||V_ESQUEMA||'.');
		
	 ELSE
	 
		-- SE CREA LA TABLA RCV_GEST_LOG EN MINIREC
	 
		DBMS_OUTPUT.PUT_LINE('[INFO] Creando la tabla '||V_TABLA||' en '||V_ESQUEMA||'.');
		
		V_SENTENCIA:= 	'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
						RGL_ID NUMBER(16,0) NOT NULL ENABLE,
						RGL_TABLA VARCHAR2(30 CHAR),
						RGL_OPERACION VARCHAR2(120 CHAR),
						RGL_INICIO_FIN VARCHAR2(10 CHAR),
						RGL_FECHA_EJEC VARCHAR2(17 CHAR) NOT NULL ENABLE,
						CONSTRAINT PK_RGL_GEST_LOG PRIMARY KEY (RGL_ID)
						)';
		
		EXECUTE IMMEDIATE V_SENTENCIA;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TABLA||' creada en '||V_ESQUEMA||'.');
		
	 END IF;
	 
	 
	COMMIT;
	
	
	-- BUSCA LA SECUENCIA S_RCV_GEST_LOG EN MINIREC

	 V_SELECT:= 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = '''||V_SECUENCIA||'''';
	 
	 EXECUTE IMMEDIATE V_SELECT INTO V_NUM;
	 DBMS_OUTPUT.PUT_LINE('[INFO] Verificando la existencia de la secuencia....');
	 
	 IF V_NUM > 0 THEN
	 
		-- LA SECUENCIA S_RCV_GEST_LOG YA EXISTE EN MINIREC
	 
		DBMS_OUTPUT.PUT_LINE('[INFO] Secuencia '||V_SECUENCIA||' ya existente en '||V_ESQUEMA||'.');
		
	 ELSE
	 
		-- SE CREA SECUENCIA S_RCV_GEST_LOG EN MINIREC
	 
		DBMS_OUTPUT.PUT_LINE('[INFO] Creando la secuencia '||V_SECUENCIA||' en '||V_ESQUEMA||'.');
		
		V_SENTENCIA:= 'CREATE SEQUENCE '||V_ESQUEMA||'.'||V_SECUENCIA||' MINVALUE 0 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER NOCYCLE';  --SE HA CAMBIADO MINVALUE DE 1 A 0 PARA QUE AL APLICARLE EL NEXTVAL EMPIEZE POR 1.

		EXECUTE IMMEDIATE V_SENTENCIA;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Secuencia '||V_SECUENCIA||' creada en '||V_ESQUEMA||'.');
		
	 END IF;
	 
	 
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]: Script ejecutado correctamente');


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
