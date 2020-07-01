--/*
--##########################################
--## AUTOR=Pablo Garcia Pallas
--## FECHA_CREACION=20200630
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-10436
--## PRODUCTO=NO
--## Finalidad: CREACION DE LA TABLA Y POBLANDO DE LA MISMA.
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE
    V_SQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_COUNT NUMBER(16); -- Vble. para contar.
    V_NUM_TABLAS NUMBER(16);
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    
    V_TABLA VARCHAR2(27 CHAR) := 'DD_EPF_ESTADO_PREFACTURA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla diccionario de estados prefactura.'; -- Vble. para los comentarios de las tablas	
    
	TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
    	T_TIPO_DATA('PEN','Pendiente','Pendiente','HREOS-10436','SYSDATE','0'),
    	T_TIPO_DATA('VAL','Validada','Validada','HREOS-10436','SYSDATE','0')
    ); 
    V_TMP_TIPO_DATA T_TIPO_DATA;
	
 BEGIN 
	
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla 
    IF V_NUM_TABLAS = 1 THEN 
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla existente');
  	
  	ELSE
		DBMS_OUTPUT.PUT_LINE('[INICIO] ' || V_ESQUEMA || '.'||V_TABLA||'... Se va ha crear.');  		
		--Creamos la tabla
		V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||' (
			DD_EPF_ID						NUMBER(16,0) NOT NULL, 
			DD_EPF_CODIGO					VARCHAR2(20CHAR) NOT NULL ENABLE,
			DD_EPF_DESCRIPCION				VARCHAR2(100CHAR),
			DD_EPF_DESCRIPCION_LARGA		VARCHAR2(250CHAR),
			USUARIOCREAR					VARCHAR2(50 CHAR)	NOT NULL ENABLE, 
			FECHACREAR						TIMESTAMP (6)		NOT NULL ENABLE, 
			USUARIOMODIFICAR				VARCHAR2(50 CHAR), 
			FECHAMODIFICAR					TIMESTAMP (6), 
			USUARIOBORRAR					VARCHAR2(50 CHAR),
			FECHABORRAR						TIMESTAMP (6), 
			BORRADO							NUMBER(1,0)			DEFAULT 0 NOT NULL ENABLE,

			CONSTRAINT PK_DD_EPF_ID PRIMARY KEY (DD_EPF_ID),
			CONSTRAINT UNIQUE_DD_EPF_CODIGO UNIQUE (DD_EPF_CODIGO)
			)';
		--DBMS_OUTPUT.PUT_LINE(V_SQL);
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
		--Creamos la secuencia
		V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
		EXECUTE IMMEDIATE V_SQL INTO V_COUNT; 
		IF V_COUNT = 0 THEN
			V_SQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TABLA||'';
			EXECUTE IMMEDIATE V_SQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] Creada la SECUENCIA S_'||V_TABLA);
		END IF;
		--Creamos comentario
		
		--NOS QUEDAMOS AQUI
		V_SQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
		EXECUTE IMMEDIATE V_SQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');		
		DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');
    END IF;
    --Se comprueba si se han insertado los nuevos registros
    -- LOOP para insertar los valores --
	DBMS_OUTPUT.PUT_LINE('[INFO]: INSERCION EN '||V_TABLA);
	FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
		LOOP		      
			V_TMP_TIPO_DATA := V_TIPO_DATA(I);
			--Comprobar el dato a insertar.
			V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE DD_EPF_CODIGO = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
			EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;			      
			IF V_NUM_TABLAS <= 0 THEN				
			    -- Si no existe se crea.
			    DBMS_OUTPUT.PUT_LINE('[INFO]: INSERTAMOS EL REGISTRO '''|| TRIM(V_TMP_TIPO_DATA(1)) ||'''');
			    V_MSQL := 'INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (DD_EPF_ID, DD_EPF_CODIGO ,DD_EPF_DESCRIPCION ,DD_EPF_DESCRIPCION_LARGA, USUARIOCREAR, FECHACREAR, BORRADO) 
				VALUES (
				S_'||V_TABLA||'.NEXTVAL,
				'''||V_TMP_TIPO_DATA(1)||''',
				'''||V_TMP_TIPO_DATA(2)||''',
				'''||V_TMP_TIPO_DATA(3)||''',
				'''||V_TMP_TIPO_DATA(4)||''',
				'||V_TMP_TIPO_DATA(5)||',
				0)';
			    DBMS_OUTPUT.PUT_LINE(V_MSQL);
			    EXECUTE IMMEDIATE V_MSQL;
			    DBMS_OUTPUT.PUT_LINE('[INFO]: REGISTRO INSERTADO CORRECTAMENTE');
			END IF;      
		END LOOP;
	
COMMIT;
DBMS_OUTPUT.PUT_LINE('[INFO] Proceso terminado.');
 
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