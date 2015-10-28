--/*
--##########################################
--## AUTOR=DAVID GONZÁLEZ
--## FECHA_CREACION=20151015
--## ARTEFACTO=
--## VERSION_ARTEFACTO=
--## INCIDENCIA_LINK=BKREC-1162
--## PRODUCTO=NO
--## Finalidad: DDL
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
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
	V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- CONFIGURACIÓN ESQUEMA
	V_TABLA VARCHAR2(30 CHAR):= 'DD_TPE_TIPO_PERSONA'; -- DECLARA LA TABLA
	V_NUM_TABLAS NUMBER(16); -- ALOJA EL RETORNO DE LA SENTENCIA SELECT
	ERR_NUM NUMBER(25); -- REGISTRA NUMERO DE ERROR DE LOS ERRORES EN EL SCRIPT
	ERR_MSG VARCHAR2(1024 CHAR); -- REGISTRA MENSAJE DE ERRORES EN EL SCRIPT
	
BEGIN
	
	-- BUSCA LA TABLA DD_TPE_TIPO_PERSONA EN BANK01	

	 V_SELECT:= 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
	 
	 EXECUTE IMMEDIATE V_SELECT INTO V_NUM_TABLAS;
	 DBMS_OUTPUT.PUT_LINE('[INFO] Verificando la existencia del registro....');
	 
	 IF V_NUM_TABLAS > 0 THEN

		
		-- BORRA LA TABLA DD_TPE_TIPO_PERSONA DE BANK01
		
		V_SENTENCIA:= 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||'';
		EXECUTE IMMEDIATE V_SENTENCIA;
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TABLA||' borrada de '||V_ESQUEMA||'.');
		
	 ELSE
	 
		DBMS_OUTPUT.PUT_LINE('[INFO] La tabla '||V_TABLA||' no existe en '||V_ESQUEMA||'.');
		
	 END IF;
	 
	 
	COMMIT;

	DBMS_OUTPUT.PUT_LINE('[FIN]: Script ejecutado correctamente');


	EXCEPTION
	
     WHEN OTHERS THEN
     
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

	END;
	/
