--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20151230
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla para gestionar el diccionario de entidades orígenes de los activos.
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
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para gestionar el diccionario de entidades orígenes de los activos.'; -- Vble. para los comentarios de las tablas

BEGIN


	DBMS_OUTPUT.PUT_LINE('******** DD_ENO_ENTIDAD_ORIGEN ********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN... Comprobaciones previas');
	

	
	-- Verificar si la tabla nueva ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_ENO_ENTIDAD_ORIGEN'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;
	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.DD_ENO_ENTIDAD_ORIGEN... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'drop table '||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN CASCADE CONSTRAINTS';
		
	END IF;
	
	
	--Verificar si la secuencia nueva existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_DD_ENO_ENTIDAD_ORIGEN'' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_SEQ;	
	
	IF V_NUM_SEQ = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_DD_ENO_ENTIDAD_ORIGEN... Ya existe. Se borrara.');
		EXECUTE IMMEDIATE 'drop sequence '||V_ESQUEMA||'.S_DD_ENO_ENTIDAD_ORIGEN';
		
	END IF;
	
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.DD_ENO_ENTIDAD_ORIGEN...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN
	(
		DD_ENO_ID           		NUMBER(16)                  NOT NULL,
		DD_ENO_CODIGO        		VARCHAR2(20 CHAR)          	NOT NULL,
		DD_ENO_PADRE_ID        		NUMBER(16),
		DD_ENO_CIF	        		VARCHAR2(20 CHAR),
		DD_ENO_DESCRIPCION       	VARCHAR2(100 CHAR),
		DD_ENO_DESCRIPCION_LARGA  	VARCHAR2(250 CHAR),
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
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN... Tabla creada.');
	
	-- Creamos indice	
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN_PK ON '||V_ESQUEMA|| '.DD_ENO_ENTIDAD_ORIGEN(DD_ENO_ID) TABLESPACE '||V_TABLESPACE_IDX;		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN_PK... Indice creado.');
	
	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN ADD (CONSTRAINT DD_ENO_ENTIDAD_ORIGEN_PK PRIMARY KEY (DD_ENO_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN_PK... PK creada.');
	
	-- Creamos sequence
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_DD_ENO_ENTIDAD_ORIGEN';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'S_DD_ENO_ENTIDAD_ORIGEN... Secuencia creada');
	
	-- Creamos foreign key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN ADD (CONSTRAINT FK_DDENTORIGPADRE_DDENTORI FOREIGN KEY (DD_ENO_PADRE_ID) REFERENCES '||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN (DD_ENO_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_DDENTORIGPADRE_DDENTORI... Foreign key creada.');
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN... Comentario creado.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.DD_ENO_ENTIDAD_ORIGEN... OK');


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