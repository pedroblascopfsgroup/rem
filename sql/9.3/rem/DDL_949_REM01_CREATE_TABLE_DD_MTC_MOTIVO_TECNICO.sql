--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20210625
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=REMVIP-10039
--## PRODUCTO=NO
--##
--## Finalidad: Crear la tabla DD_MTC_MOTIVO_TECNICO
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
    V_TABLA VARCHAR2(2400 CHAR) := 'DD_MTC_MOTIVO_TECNICO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_CHARS VARCHAR2(6 CHAR) := 'MTC';
	V_USUARIO VARCHAR2(32 CHAR) := 'REMVIP-10039';
	V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar 
	V_ESQUEMA_3 VARCHAR2(20 CHAR) := 'REM_QUERY';
	V_ESQUEMA_4 VARCHAR2(20 CHAR) := 'PFSREM';
	
    
    
 BEGIN
 
 	-- Comprobación tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] Comprobamos si existe la tabla '||V_TABLA);
	V_SQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';

	EXECUTE IMMEDIATE V_SQL INTO V_COUNT;
		
	IF V_COUNT = 0 THEN

		DBMS_OUTPUT.PUT_LINE('[INFO] Creamos la tabla '||V_TABLA);
		V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
				  DD_'||V_CHARS||'_ID NUMBER(16,0) NOT NULL
				, DD_'||V_CHARS||'_CODIGO VARCHAR2(10 CHAR) NOT NULL
				, DD_'||V_CHARS||'_DESCRIPCION VARCHAR2(100 CHAR) NOT NULL
				, DD_'||V_CHARS||'_DESCRIPCION_LARGA VARCHAR2(250 CHAR) NOT NULL
				, VERSION NUMBER(1,0) DEFAULT 0 NOT NULL
				, USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL
				, FECHACREAR TIMESTAMP(6) NOT NULL
				, USUARIOMODIFICAR VARCHAR2(50 CHAR)
				, FECHAMODIFICAR TIMESTAMP(6)
				, USUARIOBORRAR VARCHAR2(50 CHAR)
				, FECHABORRAR TIMESTAMP(6)
				, BORRADO NUMBER(1,0) DEFAULT 0 NOT NULL
				)
			  ';

		EXECUTE IMMEDIATE V_SQL;
 
		DBMS_OUTPUT.PUT_LINE('[INFO] Creada la tabla '||V_TABLA);

			-- Creamos primary key
	DBMS_OUTPUT.PUT_LINE('[INFO] Creamos la PK');
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD (CONSTRAINT '||V_TABLA||'_PK PRIMARY KEY (DD_MTC_ID))';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'_PK creada.');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] Ya existia la tabla '||V_TABLA);	
	
	END IF;


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

	IF V_ESQUEMA_M != V_ESQUEMA THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_M||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_M||''); 

END IF;

IF V_ESQUEMA_3 != V_ESQUEMA THEN

	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_3||''); 

END IF;

IF V_ESQUEMA_4 != V_ESQUEMA THEN
	
	EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_4||'" WITH GRANT OPTION';
	DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_4||''); 

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
