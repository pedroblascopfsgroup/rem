--/*
--##########################################
--## AUTOR=DAVID GONZALEZ
--## FECHA_CREACION=20160330
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla que relaciona los gestores con Provincias, Municipios y Codigos Postales
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

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla que relaciona los gestores con Provincias, Municipios y Codigos Postales.'; -- Vble. para los comentarios de las tablas

BEGIN


	DBMS_OUTPUT.PUT_LINE('******** ACT_GES_DISTRIBUCION ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.GES_DISTRIBUCION... Comprobaciones previas');
	

	
	-- Verificar si la tabla nueva ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ACT_GES_DISTRIBUCION'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
  
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.ACT_GES_DISTRIBUCION... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.ACT_GES_DISTRIBUCION CASCADE CONSTRAINTS';
		
	END IF;
	
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.ACT_GES_DISTRIBUCION...');
	V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.ACT_GES_DISTRIBUCION
	(
		COD_PROVINCIA 			    NUMBER(10,0),
		PROVINCIA	    	      	VARCHAR2(30 CHAR),
		COD_MUNICIPIO 			    NUMBER(10,0),
		MUNICIPIO	    	      	VARCHAR2(30 CHAR),
		COD_POSTAL					VARCHAR2(250 CHAR),
		USUARIO_GESTION_ACTIVOS	  	VARCHAR2(10 CHAR),
		NOMBRE_GESTION_ACTIVOS		VARCHAR2(150 CHAR),
		VERSION 					NUMBER(38,0) 				DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 				VARCHAR2(10 CHAR) 			NOT NULL ENABLE, 
		FECHACREAR 					TIMESTAMP (6) 				NOT NULL ENABLE, 
		USUARIOMODIFICAR 			VARCHAR2(10 CHAR), 
		FECHAMODIFICAR 				TIMESTAMP (6), 
		USUARIOBORRAR 				VARCHAR2(10 CHAR), 
		FECHABORRAR 				TIMESTAMP (6), 
		BORRADO 					NUMBER(1,0) 				DEFAULT 0 NOT NULL ENABLE
	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.ACT_GES_DISTRIBUCION... Tabla creada.');
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.ACT_GES_DISTRIBUCION IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACT_GES_DISTRIBUCION... Comentario creado.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.ACT_GES_DISTRIBUCION... OK');


	COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;
/

EXIT
