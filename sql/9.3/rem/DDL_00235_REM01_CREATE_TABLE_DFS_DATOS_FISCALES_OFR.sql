--/*
--##########################################
--## AUTOR=Sergio Gomez
--## FECHA_CREACION=20210506
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13453
--## PRODUCTO=NO
--## Finalidad: Crear tabla DFS_DATOS_FISCALES_OFR
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'DFS_DATOS_FISCALES_OFR'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para la recoger los datos fiscales de la Oferta.'; -- Vble. para los comentarios de las tablas
   
    --Array para crear las claves foraneas
	TYPE T_FK IS TABLE OF VARCHAR2(250);
	TYPE T_ARRAY_FK IS TABLE OF T_FK;
	V_FK T_ARRAY_FK := T_ARRAY_FK(
		-----ESQUEMA_ORIGEN --- TABLA_ORIGEN ------- CAMPO_ORIGEN -- ESQUEMA_DESTINO --- TABLA_DESTINO ---------- CAMPO_DESTINO ------ NOMBRE_F -----------    
		T_FK(''||V_ESQUEMA||'',''||V_TEXT_TABLA||'' ,'OFR_ID', 	  ''||V_ESQUEMA||'',		'OFR_OFERTAS', 				'OFR_ID', 		'FK_DFS_OFR_ID'), 
		T_FK(''||V_ESQUEMA||'',''||V_TEXT_TABLA||'' ,'DD_TIT_ID', ''||V_ESQUEMA||'',    'DD_TIT_TIPOS_IMPUESTO', 		'DD_TIT_ID',	'FK_DFS_DD_TIT_ID')		
	);

	V_TMP_FK T_FK;
	V_NUM_TABLA_REL_1 NUMBER(16); -- Vble. para validar la existencia de una tabla.  
	V_NUM_TABLA_REL_2 NUMBER(16); -- Vble. para validar la existencia de una tabla. 
	
	--Array para crear los comentarios
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('DFS_ID', 'Id de la tabla DFS_DATOS_FISCALES_OFR.'),
        T_TIPO_DATA('OFR_ID', 'Id relacional con la tabla OFR_OFERTAS.'),
        T_TIPO_DATA('DFS_NECESIDAD_IF', 'Indica la necesidad de Informe Comercial.'),
        T_TIPO_DATA('DFS_EXCLUSION_IF', 'Indica si se excluye el Informe Comercial.'),
        T_TIPO_DATA('DFS_OBSERVACIONES_IF', 'Indica las observaciones.'),
		T_TIPO_DATA('DFS_SF_VAL_INFORME_FISCAL', 'Indica la validación del informe fiscal'),		
        T_TIPO_DATA('DD_TIT_ID', 'Id relacional con la tabla DD_TIT_TIPOS_IMPUESTO.'),
        T_TIPO_DATA('DFS_TIPO_APLICABLE', 'Indica el tipo aplicable.'),
        T_TIPO_DATA('DFS_OPERACION_EXENTA', 'Indica si es operación Exenta.'),
        T_TIPO_DATA('DFS_RENUNCIA_EXENCION', 'Indica si se renuncia a la exención.'),
        T_TIPO_DATA('DFS_TRIBUTOS_PROPIEDAD', 'Indica si hay tributos sobre la propiedad.'),
        T_TIPO_DATA('DFS_INVERSION_SUJETO_PASIVO', 'Indica si hay inversión de sujeto pasivo.'),
        T_TIPO_DATA('DFS_RESERVA_CON_IMPUESTO', 'Indica si hay reserva con impuesto.'),                
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
    
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''OFR_OFERTAS'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLA_REL_1;

    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''DD_TIT_TIPOS_IMPUESTO'' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLA_REL_2;	


	IF V_NUM_TABLAS > 0 OR V_NUM_TABLA_REL_1 = 0 OR V_NUM_TABLA_REL_2 = 0 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.'||V_TEXT_TABLA||'... No se puede crear la tabla.');	
	ELSE		
		-----------------------
		---     TABLA       ---
		-----------------------
		DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TEXT_TABLA||']');
		V_SQL:= ' CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ( 
				DFS_ID				        NUMBER(16,0),
				OFR_ID				        NUMBER(16,0)        NOT NULL ENABLE,
                DFS_NECESIDAD_IF            NUMBER(1,0),
				DFS_EXCLUSION_IF            NUMBER(1,0),
				DFS_OBSERVACIONES_IF		VARCHAR2(4000 CHAR),
				DFS_SF_VAL_INFORME_FISCAL   NUMBER(1,0),
				DD_TIT_ID 				    NUMBER(16,0),
				DFS_TIPO_APLICABLE          NUMBER(16,2),
                DFS_OPERACION_EXENTA        NUMBER(1,0),
                DFS_RENUNCIA_EXENCION       NUMBER(1,0),
                DFS_TRIBUTOS_PROPIEDAD      NUMBER(1,0),
                DFS_INVERSION_SUJETO_PASIVO NUMBER(1,0),
                DFS_RESERVA_CON_IMPUESTO    NUMBER(1,0),
				VERSION				        NUMBER(38,0)		DEFAULT 0 NOT NULL ENABLE,
				USUARIOCREAR		        VARCHAR2(50 CHAR)	NOT NULL ENABLE, 
				FECHACREAR			        TIMESTAMP (6)		NOT NULL ENABLE, 
				USUARIOMODIFICAR	        VARCHAR2(50 CHAR), 
				FECHAMODIFICAR		        TIMESTAMP (6), 
				USUARIOBORRAR		        VARCHAR2(50 CHAR), 
				FECHABORRAR			        TIMESTAMP (6), 
				BORRADO				        NUMBER(1,0)			DEFAULT 0 NOT NULL ENABLE
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
			EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD CONSTRAINT PK_'||V_TEXT_TABLA||' PRIMARY KEY (DFS_ID)';               				
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