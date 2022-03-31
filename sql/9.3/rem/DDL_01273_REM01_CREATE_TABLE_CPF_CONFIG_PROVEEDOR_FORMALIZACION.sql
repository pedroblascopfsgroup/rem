--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220330
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17581
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla CPF_CONFIG_PVE_FORMALIZACION
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar         
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TABLA VARCHAR2(2400 CHAR) := 'CPF_CONFIG_PVE_FORMALIZACION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_CHARS VARCHAR2(6 CHAR) := 'CPF';
	V_USUARIO VARCHAR2(32 CHAR) := 'HREOS-17581';
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
	
    
    
 BEGIN
 
 	-- Comprobación tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos si existe la tabla '||V_TABLA);
	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';

	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
	IF V_COUNT = 0 THEN

		DBMS_OUTPUT.PUT_LINE('[INFO] Creamos la tabla '||V_TABLA);
		V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
				  '||V_CHARS||'_ID NUMBER(16,0) NOT NULL
				,  PVE_ID NUMBER(16,0)
				, '||V_CHARS||'_FORMALIZACION_CAJAMAR NUMBER(1,0) DEFAULT 0 NOT NULL
				
				)
			  ';

		EXECUTE IMMEDIATE V_SQL;
 
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_TABLA);

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la tabla '||V_TABLA);	
	
	END IF;

	-- Creamos primary key
	DBMS_OUTPUT.PUT_LINE('[INFO] Creamos la PK');
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (CPF_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'_PK creada.');

    -- Creamos foreign key
	DBMS_OUTPUT.PUT_LINE('[INFO] Creamos la FK');
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||'
             ADD CONSTRAINT FK_CPF_PVE
             FOREIGN KEY (PVE_ID) REFERENCES ACT_PVE_PROVEEDOR(PVE_ID)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'_FK creada.');

	-- Comprobamos sequence
	DBMS_OUTPUT.PUT_LINE('[INFO] Creamos la secuencia');
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	 
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 

	IF V_COUNT = 0 THEN
	 
		-- Creamos sequence	 
		V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la SECUENCIA S_'||V_TABLA);

	ELSE
		
		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la secuencia S_'||V_TABLA);	
	  
	END IF;


	

COMMIT;
 
EXCEPTION
     WHEN OTHERS THEN
          ERR_NUM := SQLCODE;
          ERR_MSG := SQLERRM;
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(ERR_NUM));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(ERR_MSG);
          ROLLBACK;
          RAISE;   
END;
/
EXIT;
