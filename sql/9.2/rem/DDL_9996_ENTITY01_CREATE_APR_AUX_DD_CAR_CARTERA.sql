--/*
--##########################################
--## AUTOR=David Gonzalez
--## FECHA_CREACION=20180418
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=RECOVERY-11088
--## PRODUCTO=NO
--##
--## Finalidad: Script que crea tabla auxiliar APR_AUX_DD_CAR_CARTERA
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

    V_MSQL VARCHAR2( 32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2( 25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2( 25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2( 4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER( 16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ NUMBER( 16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM NUMBER( 25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2( 1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2( 2400 CHAR); -- Vble. auxiliar 
    V_TEXT_TABLA VARCHAR2( 2400 CHAR) := 'APR_AUX_DD_CAR_CARTERA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2( 500 CHAR):= 'Tabla auxiliar para almacenar la información del diccionario CAR_CARTERA de Haya03.'; -- Vble. para los comentarios de las tablas

BEGIN
	
	DBMS_OUTPUT.PUT_LINE('********' ||V_TEXT_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas');
	

	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT( 1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
		
	END IF; 
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(
		CAR_ID					NUMBER(16,0),
		CAR_DESCRIPCION			VARCHAR2(50 CHAR),
		CAR_DESCRIPCION_LARGA	VARCHAR2(250 CHAR),
		VERSION					NUMBER(38,0),
		USUARIOCREAR			VARCHAR2(50 CHAR),
		FECHACREAR				TIMESTAMP(6),
		USUARIOMODIFICAR		VARCHAR2(50 CHAR),
		FECHAMODIFICAR			TIMESTAMP(6),
		USUARIOBORRAR			VARCHAR2(50 CHAR),
		FECHABORRAR				TIMESTAMP(6),
		BORRADO					NUMBER(1,0),
		TIPO_CARTERA_ID			NUMBER(16,0),
		FECHACESION				TIMESTAMP(6),
		FECHANOTIFIC			TIMESTAMP(6),
		CEDENTE					VARCHAR2(100 CHAR),
		NOTARIO					VARCHAR2(100 CHAR),
		PROTOCOLO				VARCHAR2(10 CHAR),
		OFICINA					VARCHAR2(4 CHAR),
		CAR_PARRAFO_CEDENTE1	VARCHAR2(4000 CHAR),
		CAR_PARRAFO_CEDENTE2	VARCHAR2(4000 CHAR),
		CAR_TEXTO_DOC2			VARCHAR2(4000 CHAR),
		CAR_TEXTO_DOC3			VARCHAR2(4000 CHAR),
		CAR_DOBLE_CESION		NUMBER(1,0),
		CODIGO_CLIENTE			VARCHAR2(10 CHAR),
		CAR_CODIGO				VARCHAR2(10 CHAR)
	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');


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

EXIT;
