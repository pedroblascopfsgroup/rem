--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220503
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17766
--## PRODUCTO=NO
--## Finalidad: Creación diccionario AUX_DELEGACIONES_API
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'AUX_DELEGACIONES_API'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

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
		 ID_REM								NUMBER(16,0)  			NOT NULL
		,ID_DELEGACION						NUMBER(16,0)  			
		,DELEGACION							NUMBER(16,0)  			NOT NULL
		,D_TIPO_VIA							VARCHAR2(2 CHAR)		NOT NULL
		,D_NOMBRE_VIA						VARCHAR2(50 CHAR)		NOT NULL
		,D_NUMERO							VARCHAR2(50 CHAR)		NOT NULL
		,D_PLANTA							VARCHAR2(50 CHAR)
		,D_PUERTA							VARCHAR2(50 CHAR)
		,D_OTROS							VARCHAR2(50 CHAR)
		,D_MUNICIPIO						VARCHAR2(5 CHAR)		NOT NULL
		,D_CP								VARCHAR2(5 CHAR)		NOT NULL
		,D_PROVINCIA						VARCHAR2(2 CHAR)		NOT NULL
		,D_TELEFONO	 	          			NUMBER(12,0)			NOT NULL
		,D_TELEFONO_2	 	          		NUMBER(12,0)
		,D_EMAIL							VARCHAR2(100 CHAR)		NOT NULL
		,D_NOMBRE_PERSONA_CONTACTO			VARCHAR2(50 CHAR)		NOT NULL
		,D_EMAIL_PERSONA_CONTACTO			VARCHAR2(50 CHAR)		NOT NULL
		,D_LINEA_NEGOCIO					VARCHAR2(2 CHAR)		NOT NULL
		,D_ESPECIALIDAD						VARCHAR2(255 CHAR)		NOT NULL
		,D_IDIOMAS							VARCHAR2(255 CHAR)		NOT NULL
		,D_GESTION_CLIENTES_RESIDENTES		VARCHAR2(2 CHAR)		NOT NULL
		,D_NUMERO_COMERCIALES				NUMBER(16,0)			NOT NULL
		,D_ZONA_ACTUACION_PROVINCIAS		VARCHAR2(255 CHAR) 		NOT NULL
		,D_ZONA_ACTUACION_MUNICIPIOS		VARCHAR2(255 CHAR) 		NOT NULL
		,D_ZONA_ACTUACION_CP				VARCHAR2(255 CHAR) 		NOT NULL

	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
	
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
