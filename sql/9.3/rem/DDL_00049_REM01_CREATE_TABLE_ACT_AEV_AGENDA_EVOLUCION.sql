--/*
--##########################################
--## AUTOR=SERGIO GOMEZ TORRES
--## FECHA_CREACION=20200629
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10488
--## PRODUCTO=NO
--## Finalidad: Crear tabla para la nueva subpestaña 'Evolución', dentro de la pestaña 'Admisión'
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'ACT_AEV_AGENDA_EVOLUCION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para la subpestanya Evolucion, dentro de la pestanya Admision.'; -- Vble. para los comentarios de las tablas
   
    --Array para crear las claves foraneas
	TYPE T_FK IS TABLE OF VARCHAR2(250);
	TYPE T_ARRAY_FK IS TABLE OF T_FK;
	V_FK T_ARRAY_FK := T_ARRAY_FK(
		-----ESQUEMA_ORIGEN --- TABLA_ORIGEN ------- CAMPO_ORIGEN -- ESQUEMA_DESTINO --- TABLA_DESTINO ---------- CAMPO_DESTINO ------ NOMBRE_F -----------    
		T_FK(''||V_ESQUEMA||'',''||V_TEXT_TABLA||'' ,'ACT_ID', 	  ''||V_ESQUEMA||'',		'ACT_ACTIVO', 				'ACT_ID', 		'FK_ACT_ACTIVO_ACT_ID'), 
		T_FK(''||V_ESQUEMA||'',''||V_TEXT_TABLA||'' ,'DD_EAA_ID', ''||V_ESQUEMA||'','DD_EAA_ESTADO_ACT_ADMISION', 		'DD_EAA_ID',	'FK_DD_EAA_ID_DD_EAA_EST_ACT_ADMIS'), 
		T_FK(''||V_ESQUEMA||'',''||V_TEXT_TABLA||'' ,'DD_SAA_ID', ''||V_ESQUEMA||'','DD_SAA_SUBESTADO_ACT_ADMISION', 	'DD_SAA_ID', 	'FK_DD_SAA_SUBESTA_ACT_ADMIS'), 
		T_FK(''||V_ESQUEMA||'',''||V_TEXT_TABLA||'' ,'USU_ID',	  ''||V_ESQUEMA_M||'','USU_USUARIOS', 					'USU_ID', 		'FK_USU_ID_USU_USUARIOS') 
	);      
	V_TMP_FK T_FK;
	V_NUM_TABLA_REL_1 NUMBER(16); -- Vble. para validar la existencia de una tabla.  
	V_NUM_TABLA_REL_2 NUMBER(16); -- Vble. para validar la existencia de una tabla.
	V_NUM_TABLA_REL_3 NUMBER(16); -- Vble. para validar la existencia de una tabla.
	V_NUM_TABLA_REL_4 NUMBER(16); -- Vble. para validar la existencia de una tabla.  
	
	--Array para crear los comentarios
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('AEV_ID', 'Id de la tabla ACT_AEV_AGENDA_EVOLUCION.'),
        T_TIPO_DATA('ACT_ID', 'Id relacional con la tabla ACT_ACTIVO.'),
        T_TIPO_DATA('DD_EAA_ID', 'Id relacional con la tabla DD_EAA_ESTADO_ACT_ADMISION.'),
        T_TIPO_DATA('DD_SAA_ID', 'Id relacional con la tabla DD_SAA_SUBESTADO_ACT_ADMISION.'),
        T_TIPO_DATA('AEV_FECHA', 'Indica la fecha de la agenda.'),
        T_TIPO_DATA('USU_ID', 'Id relacional con la tabla USU_USUARIOS.'),
        T_TIPO_DATA('AEV_OBSERVACIONES', 'Indica las observaciones del registro.'),
        T_TIPO_DATA('VERSION', 'Indica la version del registro.'),
        T_TIPO_DATA('USUARIOCREAR', 'Indica el usuario que creo el registro.'),
        T_TIPO_DATA('FECHACREAR', 'Indica la fecha en la que se creo el registro.'),
        T_TIPO_DATA('USUARIOMODIFICAR', 'Indica el usuario que modificó el registro.'),
        T_TIPO_DATA('FECHAMODIFICAR', 'Indica la fecha en la que se modificó el registro.'),
        T_TIPO_DATA('USUARIOBORRAR', 'Indica el usuario que borró el registro.'),
        T_TIPO_DATA('FECHABORRAR', 'Indica la fecha en la que se borró el registro.'),
        T_TIPO_DATA('BORRADO', 'Indicador de borrado.')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
  
BEGIN
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
    
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''ACT_ACTIVO'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLA_REL_1;

    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_EAA_ESTADO_ACT_ADMISION'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLA_REL_2;	
    
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_SAA_SUBESTADO_ACT_ADMISION'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLA_REL_3;	

	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''USU_USUARIOS'' and owner = '''||V_ESQUEMA_M||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLA_REL_4;

	IF V_NUM_TABLAS > 0 OR V_NUM_TABLA_REL_1 = 0 OR V_NUM_TABLA_REL_2 = 0 OR V_NUM_TABLA_REL_3 = 0 OR V_NUM_TABLA_REL_4 = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'... No se puede crear la tabla.');	
	ELSE		
		-----------------------
		---     TABLA       ---
		-----------------------
		DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TEXT_TABLA||']');
		V_SQL:= ' CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ( 
				AEV_ID				NUMBER(16,0),
				ACT_ID				NUMBER(16,0),
				DD_EAA_ID           NUMBER(16,0),
				DD_SAA_ID           NUMBER(16,0),
				AEV_FECHA			DATE,
				USU_ID 				NUMBER(16,0),
				AEV_OBSERVACIONES   CLOB,
				VERSION				NUMBER(38,0)		DEFAULT 0 NOT NULL ENABLE,
				USUARIOCREAR		VARCHAR2(50 CHAR)	NOT NULL ENABLE, 
				FECHACREAR			TIMESTAMP (6)		NOT NULL ENABLE, 
				USUARIOMODIFICAR	VARCHAR2(50 CHAR), 
				FECHAMODIFICAR		TIMESTAMP (6), 
				USUARIOBORRAR		VARCHAR2(50 CHAR), 
				FECHABORRAR			TIMESTAMP (6), 
				BORRADO				NUMBER(1,0)			DEFAULT 0 NOT NULL ENABLE
			)';
	
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('['||V_TEXT_TABLA||' CREADA]');
	
		-- Creamos comentario tabla
		V_SQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||''''; 
        
		EXECUTE IMMEDIATE V_SQL;
        		
		-- Creamos comentarios columnas
		FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
	
			V_SQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TEXT_TABLA||'.'||V_TMP_TIPO_DATA(1)||' IS '''||V_TMP_TIPO_DATA(2)||'''';      
			EXECUTE IMMEDIATE V_SQL;
		END LOOP; 		
		---------------------------
		-------     PK      -------
		---------------------------
		EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||''' and CONSTRAINT_TYPE = ''P'''
		INTO V_NUM_TABLAS; 
		
		IF V_NUM_TABLAS > 0 THEN
			DBMS_OUTPUT.PUT_LINE('  [INFO] La PK PK_'||V_TEXT_TABLA||'... Ya existe.');                 
		ELSE
			DBMS_OUTPUT.PUT_LINE('  [INFO] Creando PK_'||V_TEXT_TABLA||'...');           
			EXECUTE IMMEDIATE 'ALTER TABLE '||V_TEXT_TABLA||' 
				ADD (CONSTRAINT PK_'||V_TEXT_TABLA||' PRIMARY KEY (AEV_ID))';               				
			--------------------------------
			---     CLAVES FORANEAS      ---
			--------------------------------    
		
			DBMS_OUTPUT.PUT_LINE('[INICIO CLAVES FORANEAS]');
	
			FOR J IN V_FK.FIRST .. V_FK.LAST
			LOOP
				V_TMP_FK := V_FK(J);
		
				EXECUTE IMMEDIATE '
					SELECT COUNT(1)
					FROM ALL_CONSTRAINTS CONS
					INNER JOIN ALL_CONS_COLUMNS COL ON COL.CONSTRAINT_NAME = CONS.CONSTRAINT_NAME
					WHERE CONS.OWNER = '''||V_TMP_FK(1)||''' 
					AND CONS.TABLE_NAME = '''||V_TMP_FK(2)||''' 
					AND CONS.CONSTRAINT_TYPE = ''R''
					AND COL.COLUMN_NAME = '''||V_TMP_FK(3)||''''
				INTO V_NUM_TABLAS;
		
				IF V_NUM_TABLAS > 0 THEN
					DBMS_OUTPUT.PUT_LINE('  [INFO] La FK '||V_TMP_FK(7)||'... Ya existe.');                 
				ELSE
					DBMS_OUTPUT.PUT_LINE('  [INFO] Creando '||V_TMP_FK(7)||'...');           
			
					V_SQL := 'ALTER TABLE '||V_TMP_FK(1)||'.'||V_TMP_FK(2)||' 
						ADD (CONSTRAINT '||V_TMP_FK(7)||' FOREIGN KEY ('||V_TMP_FK(3)||') 
						REFERENCES '||V_TMP_FK(4)||'.'||V_TMP_FK(5)||' ('||V_TMP_FK(6)||') ON DELETE SET NULL)';   
                        
                    DBMS_OUTPUT.PUT_LINE(V_SQL);
                    EXECUTE IMMEDIATE V_SQL;
				END IF;
		
			END LOOP; 
			DBMS_OUTPUT.PUT_LINE('[FIN CLAVES FORANEAS]');
		END IF;
	END IF;

		-- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
		
	END IF; 

		-- Creamos sequence
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');


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
    
    ROLLBACK;
    RAISE;          

END;

/

EXIT;