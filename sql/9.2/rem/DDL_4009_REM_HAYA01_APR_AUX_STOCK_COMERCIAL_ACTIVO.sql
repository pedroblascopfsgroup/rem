--/*
--##########################################
--## AUTOR=JAVIER DIAZ
--## FECHA_CREACION=20160331
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla auxiliar para el aprovisionamiento de la información de los activos de REM-UVEM - Generación de Excel.
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_STOCK_COMERCIAL_ACTIVO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
	V_TEXT_TABLA_IN VARCHAR2(2400 CHAR) := 'APR_AUX_STOCK_COMERCIAL_ACT'; -- INDICE DE LA TABLA CREADA.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla auxiliar para el aprovisionamiento de la información de los activos de REM-UVEM - Generación de Excel.'; -- Vble. para los comentarios de las tablas

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
		
	END IF;

	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(
		

		ID_PROPIETARIO					NUMBER(9) NOT NULL,
		TIPO_INMUEBLE					VARCHAR2(2 CHAR) NOT NULL,
		TIPO_DISTRIBUCION				VARCHAR2(2 CHAR) NOT NULL,
		DESCRIPCION					VARCHAR2(4000 CHAR),
		DIRECCION					VARCHAR2(60 CHAR) NOT NULL,
		NUMERO						VARCHAR2(17 CHAR),
		ESCALERA					VARCHAR2(5 CHAR),
        	NRO_PLANTA					VARCHAR2(11 CHAR),
		PUERTA						VARCHAR2(17 CHAR)  	NOT NULL,
		COD_MUNICIPIO					NUMBER(9)		NOT NULL,
		CP						NUMBER(9),
		VPO						VARCHAR2(2 CHAR),
		NROS_DE_PLANTAS					NUMBER(1),
		BAÑOS						NUMBER(9),
		ASESOS						NUMBER(9),
		DORMITORIOS					NUMBER(9),
		PRECIO_MINIMO					NUMBER(13)		NOT NULL,
		PRECIO_VENTA					NUMBER(13)		NOT NULL,
		SUPERFICIE_CONSTRUIDA				NUMBER(13,3),
		SUPERFICIE_UTIL					NUMBER(13,3),
		GARAJE_Y_O_TRASTERO				VARCHAR2(10 CHAR),
		FINCA_REGISTRAL					VARCHAR2(9 CHAR)		NOT NULL,
		REG_DE_LA_PROPIEDAD				VARCHAR2(30 CHAR)		NOT NULL,
		NRO_DE_REGISTRO					NUMBER(9)		NOT NULL,
		CEE						VARCHAR2(2 CHAR),
		FECHA_CEE					DATE,	
		T_EXPLOT_DOM					VARCHAR2(50 CHAR)		NOT NULL,
		POR_PROP					NUMBER(5,2)		NOT NULL,
		USO_CARACTERISTICO				NUMBER(1)		NOT NULL,
		LONGITUD					NUMBER(21,15),
		LATITUD						NUMBER(21,15),
                REFERENCIA_CASTRAL				VARCHAR2(20 CHAR),
		OCUPADO						VARCHAR2(2 CHAR),
		LLAVES						DATE,
		POSESION					VARCHAR2(2 CHAR),
		FECHA_POSESION					DATE,
		INSCRIPCION					VARCHAR2(2 CHAR),
	   	FECHA_INS_TITULO				DATE,
		OBRA_NUEVA					VARCHAR2(2 CHAR),
		FECHA_ENTRADA					DATE,
		USUARIOCREAR 					VARCHAR2(50 CHAR), 
		FECHACREAR 						TIMESTAMP (6), 
		USUARIOMODIFICAR 				VARCHAR2(50 CHAR), 
		FECHAMODIFICAR 					TIMESTAMP (6), 
		USUARIOBORRAR 					VARCHAR2(50 CHAR), 
		FECHABORRAR 					TIMESTAMP (6), 
		BORRADO 						NUMBER(1,0)
	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
	

	-- Creamos indice	
	V_MSQL := 'CREATE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA_IN||'_IN ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(ID_PROPIETARIO) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA_IN||'_IN... Indice creado.');
	
	
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');
	
COMMIT;



EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificada');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
