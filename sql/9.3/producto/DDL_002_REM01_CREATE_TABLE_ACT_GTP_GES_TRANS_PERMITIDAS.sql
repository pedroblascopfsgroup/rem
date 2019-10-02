--/*
--##########################################
--## AUTOR=ALVARO GARCIA
--## FECHA_CREACION=20191003
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK= HREOS-7803
--## PRODUCTO=NO
--## 
--## Finalidad: Creación de tablas ACT_GTP_GES_TRANS_PERMITIDAS
--## INSTRUCCIONES:  Configurar las variables necesarias en el principio del DECLARE
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_GTP_GES_TRANS_PERMITIDAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_TEXT_CONST VARCHAR2(2400 CHAR) := 'ACT_GTP_GES_TRANS_PERMITIDAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= ''; -- Vble. para los comentarios de las tablas
    V_PK_COLUMN VARCHAR2(500 CHAR):= 'GTP_ID'; -- Vble. para la columna PK
    TYPE T_FK IS TABLE OF VARCHAR2(150);
    TYPE T_COMMENT IS TABLE OF VARCHAR2(150);

    TYPE T_ARRAY_FK IS TABLE OF T_FK;
    V_FK T_ARRAY_FK := T_ARRAY_FK(
    --              COLUMN  	   TABLE    				OWNER
    	T_FK('DD_TPR_ID',   'DD_TPR_TIPO_PROVEEDOR',		''||V_ESQUEMA||''), 
      	T_FK('DD_TGE_ID',   'DD_TGE_TIPO_GESTOR',		''||V_ESQUEMA_M||''), 
      	T_FK('TFP_ID',   'ACT_TFP_TRANSICIONES_FASESP',  	''||V_ESQUEMA||'')
    ); 
  V_TMP_FK T_FK;

    TYPE T_ARRAY_COMMENT IS TABLE OF T_COMMENT;
    V_COMMENT T_ARRAY_COMMENT := T_ARRAY_COMMENT(
    --              COLUMN  	   COMMENT    			
      	T_COMMENT('GTP_ID',   'Código identificador único de control del gestor de transacciones permitidas'), 
      	T_COMMENT('DD_TGE_ID',   'Código identificador único de tipo de gestor.'),
      	T_COMMENT('DD_TPR_ID',   'Código identificador único de tipo de proveedor.'),
      	T_COMMENT('TFP_ID',   'Código identificador único de control de fase previa del activo.'),
      	T_COMMENT('GTP_TOTAL',   'Total de transacciones permitidas'),
      	T_COMMENT('VERSION',   'Indica la version del registro.'),
      	T_COMMENT('USUARIOCREAR',   'Indica el usuario que creo el registro.'),
      	T_COMMENT('FECHACREAR',   'Indica la fecha en la que se creo el registro.'),
      	T_COMMENT('USUARIOMODIFICAR',   'Indica el usuario que modificó el registro.'),
      	T_COMMENT('FECHAMODIFICAR',   'Indica la fecha en la que se modificó el registro.'),
      	T_COMMENT('USUARIOBORRAR',   'Indica el usuario que borró el registro.'),
      	T_COMMENT('FECHABORRAR',   'Indica la fecha en la que se borró el registro.'),
      	T_COMMENT('BORRADO',   'Indicador de borrado.')
    ); 
    V_TMP_COMMENT T_COMMENT;

BEGIN


	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla ya existe
	V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
		
	END IF;

	-- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
		
	END IF; 
	
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_SQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(
		GTP_ID 				NUMBER(16,0) 		    NOT NULL, 
		DD_TGE_ID 			NUMBER(16,0), 
		DD_TPR_ID 			NUMBER(16,0), 
		TFP_ID 				NUMBER(16,0), 
		GTP_TOTAL 			NUMBER(1,0) 		    DEFAULT 0 NOT NULL , 
		VERSION 			NUMBER(38,0) 		    DEFAULT 0 NOT NULL ENABLE, 
		USUARIOCREAR 			VARCHAR2(50 CHAR) 	    NOT NULL ENABLE, 
		FECHACREAR 			TIMESTAMP (6) 		    NOT NULL ENABLE, 
		USUARIOMODIFICAR 		VARCHAR2(50 CHAR), 
		FECHAMODIFICAR 			TIMESTAMP (6), 
		USUARIOBORRAR 			VARCHAR2(50 CHAR), 
		FECHABORRAR 			TIMESTAMP (6), 
		BORRADO 			NUMBER(1,0) 		    DEFAULT 0 NOT NULL ENABLE
	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
	

	-- Creamos indice	
	V_SQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_CONST||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'('||TRIM(V_PK_COLUMN)||') TABLESPACE '||V_TABLESPACE_IDX;		
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_CONST||'_PK... Indice creado.');
	
	
	-- Creamos primary key
	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_CONST||'_PK PRIMARY KEY ('||TRIM(V_PK_COLUMN)||') USING INDEX)';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_CONST||'_PK... PK creada.');


	-- Creamos sequence
	V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
	EXECUTE IMMEDIATE V_SQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');

	
	-- Creamos FK's
 	FOR I IN V_FK.FIRST .. V_FK.LAST
      	LOOP

	V_TMP_FK := V_FK(I);
	V_SQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD FOREIGN KEY ('||TRIM(V_TMP_FK(1))||') REFERENCES '||TRIM(V_TMP_FK(3))||'.'||TRIM(V_TMP_FK(2))||'('||TRIM(V_TMP_FK(1))||')';
	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');

	END LOOP;

	-- Creamos comentarios	
	V_SQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		

	FOR I IN V_COMMENT.FIRST .. V_COMMENT.LAST
    LOOP

	V_TMP_COMMENT := V_COMMENT(I);

	V_SQL := 'COMMENT ON COLUMN ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||TRIM(V_TMP_COMMENT(1))||' IS '''||TRIM(V_TMP_COMMENT(2))||'''';

	EXECUTE IMMEDIATE V_SQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');

   	END LOOP;

	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');

	COMMIT;


EXCEPTION
     WHEN OTHERS THEN 
         DBMS_OUTPUT.PUT_LINE('KO!');
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);
          DBMS_OUTPUT.put_line('-----------------------V_SQL--------------------------------'); 
	  DBMS_OUTPUT.put_line(V_SQL); 
          ROLLBACK;
          RAISE;          

END;

/

EXIT;
