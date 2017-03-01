--/*
--##########################################
--## AUTOR=Teresa Alonso
--## FECHA_CREACION=20170301
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-1573
--## PRODUCTO=NO
--## Finalidad: Interfaz Stock REM - UVEM
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_VIS_FILTRO'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla auxiliar para almacenar la información de la vista materializada procedente de BD REM.'; -- Vble. para los comentarios de las tablas

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

	-- Comprobamos si existe la secuencia
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TEXT_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TEXT_TABLA||'... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';
		
	END IF; 
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(
		ACT_ID			NUMBER(16,0),
		NUMERO_ACTIVO		NUMBER(16,0), 
		ACT_NUM_ACTIVO_REM 	NUMBER(16,0), 
		COACES			VARCHAR2(9 CHAR) NOT NULL,
		NURCAT 			VARCHAR2(20 CHAR) ,
		CASUTR 			VARCHAR2(11 CHAR) ,
		CASUTG 			VARCHAR2(11 CHAR) ,
		CASUTC 			VARCHAR2(11 CHAR) ,
		CADORM 			VARCHAR2(4 CHAR) ,
		CABANO 			VARCHAR2(4 CHAR) ,
		BIGAPA 			VARCHAR2(1 CHAR) ,
		CAGAPA 			VARCHAR2(5 CHAR) ,
		BIASCE 			VARCHAR2(1 CHAR) 

	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');


	-- Creamos sequence
--	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
--	EXECUTE IMMEDIATE V_MSQL;		
--	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
	
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
	
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');

        EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ACT_ID IS ''Código identificador único del activo''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.NUMERO_ACTIVO IS ''Código identificador único del activo en HAYA''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ACT_NUM_ACTIVO_REM IS ''Código identificador único del activo en REM''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COACES IS ''Código identificador único del activo en UVEM''';

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.NURCAT IS ''REFERENCIA_CATASTRAL X(20)''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CASUTR IS ''SUP_TOTAL_REAL_UTIL 9(9)V99''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CASUTG IS ''SUP_TOTAL_REGISTRAL_UTIL 9(9)V99''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CASUTC IS ''SUP_TOTAL_REAL_CONSTRUIDA 9(9)V99''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CADORM IS ''DORMITORIOS_ACTIVO 9(4)''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CABANO IS ''BANIOS_ACTIVO 9(4)''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIGAPA IS ''GARAJE X(1)''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CAGAPA IS ''NUM_PLAZAS_GARAJE 9(5)''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIASCE IS ''ASCENSOR_ACTIVO X(1)''';

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

EXIT;
