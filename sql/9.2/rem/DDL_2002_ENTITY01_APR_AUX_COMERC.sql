--/*
--##########################################
--## AUTOR=Daniel Albert
--## FECHA_CREACION=20160915
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla auxiliar para la salida de la interfaz REM -> UVEM de Comercialización
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
    V_NUM_TABLAS VARCHAR2(16); -- Vble. para validar la existencia de una tabla.  
    V_NUM_SEQ VARCHAR2(16); -- Vble. para validar la existencia de una secuencia.  
    ERR_NUM VARCHAR2(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_COMERC'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla auxiliar para la salida de la interfaz REM -> UVEM de Comercialización'; -- Vble. para los comentarios de las tablas

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
		CORTOH				VARCHAR2(2 CHAR),
		COACHY				VARCHAR2(1 CHAR),
		COENGP				VARCHAR2(5 CHAR),
		COENOR				VARCHAR2(5 CHAR),
		COSPAT				VARCHAR2(5 CHAR),
		COESVE				VARCHAR2(9 CHAR),
		COACES				VARCHAR2(9 CHAR),
		COOFET				VARCHAR2(9 CHAR),
		COOFHY				VARCHAR2(16 CHAR),
		COSIOF				VARCHAR2(2 CHAR),
		COFAOF				VARCHAR2(2 CHAR),
		FBOFER				VARCHAR2(8 CHAR),
		FECHIF				VARCHAR2(8 CHAR),
		FXTRAB				VARCHAR2(8 CHAR),
		IMOFER				VARCHAR2(12 CHAR),
		FEPRES				VARCHAR2(8 CHAR),
		BIFICL				VARCHAR2(10 CHAR),
		COTIG1				VARCHAR2(3 CHAR),
		OBFINE				VARCHAR2(55 CHAR),
		IMDIDO				VARCHAR2(15 CHAR),
		IDCOOF				VARCHAR2(4 CHAR),
		IMCAPO				VARCHAR2(15 CHAR),
		IMRESP				VARCHAR2(15 CHAR),
		IMVACT				VARCHAR2(15 CHAR),
		FANRES				VARCHAR2(8 CHAR),
		COREDV				VARCHAR2(1 CHAR),
		COSANO				VARCHAR2(3 CHAR),
		BICAAP				VARCHAR2(1 CHAR),
		COTIRG				VARCHAR2(5 CHAR),
		NUIDOP				VARCHAR2(20 CHAR),
		OBDEER				VARCHAR2(80 CHAR),
		VERSION 			VARCHAR2(38 CHAR) 		DEFAULT 0 NOT NULL ENABLE,
		USUARIOCREAR 		VARCHAR2(50 CHAR) 	NOT NULL ENABLE,
		FECHACREAR 			TIMESTAMP(6) 		NOT NULL ENABLE,
		USUARIOMODIFICAR	VARCHAR2(50 CHAR),
		FECHAMODIFICAR 		TIMESTAMP(6),
		USUARIOBORRAR 		VARCHAR2(50 CHAR),
		FECHABORRAR 		TIMESTAMP(6),
		BORRADO 			VARCHAR2(1 CHAR) 		DEFAULT 0 NOT NULL ENABLE
	)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');

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
