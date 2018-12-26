--/*
--##########################################
--## AUTOR=Maria Presencia
--## FECHA_CREACION=20181116
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.4
--## INCIDENCIA_LINK=HREOS-4717
--## PRODUCTO=NO
--## 
--## Finalidad:           
--## INSTRUCCIONES: Creacion tabla TMP_MAPEO_PUBLICACION_INICIAL
--## VERSIONES:
--##           0.1 Version inicial (Maria Presencia)
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
    V_TABLA VARCHAR2(50 CHAR) := 'TMP_MAPEO_PUBLICACION_INICIAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para el mapeo del modulo publicacion inicial.'; -- Vble. para los comentarios de las tablas


BEGIN


	-----------------------------------------------------------------------------------------------------------
	------------------- 		CREACION TABLA TMP_MAPEO_PUBLICACION_INICIAL  	-----------------------------------
	-----------------------------------------------------------------------------------------------------------
	DBMS_OUTPUT.PUT_LINE('********' ||V_TABLA|| '********'); 
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas');
	
	
	-- Verificar si la tabla ya existe
	V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;	
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' CASCADE CONSTRAINTS';
		
	END IF;

		
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TABLA||'
	(
		    DD_TCO_CODIGO					VARCHAR2(20 BYTE), 
			DD_EPU_CODIGO					VARCHAR2(20 CHAR), 
			DD_EPV_CODIGO					VARCHAR2(20 CHAR),
			DD_TPU_V_CODIGO					VARCHAR2(20 CHAR),
			APU_CHECK_PUBLICAR_V			NUMBER(1,0), 
			APU_CHECK_OCULTAR_V				NUMBER(1,0), 
			APU_CHECK_OCULT_PRECIO_V		NUMBER(1,0), 
			APU_CHECK_PUB_SIN_PRECIO_V		NUMBER(1,0), 
			DD_MTO_V_CODIGO					VARCHAR2(20 CHAR), 
			MTO_OCULTACION_V				VARCHAR2(100 CHAR), 
			DD_EPA_CODIGO					VARCHAR2(20 BYTE), 
			DD_TPU_A_CODIGO					VARCHAR2(100 BYTE),
			APU_CHECK_PUBLICAR_A			NUMBER(1,0), 
			APU_CHECK_OCULTAR_A				NUMBER(1,0), 
			APU_CHECK_OCULT_PRECIO_A		NUMBER(1,0), 
			APU_CHECK_PUB_SIN_PRECIO_A		NUMBER(1,0), 
			DD_MTO_A_CODIGO					VARCHAR2(20 BYTE), 
			MTO_OCULTACION_A				VARCHAR2(100 BYTE)

	)
	LOGGING 
	NOCOMPRESS 
	NOCACHE
	NOPARALLEL
	NOMONITORING
	';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Tabla creada.');
	
	
	-- Comentarios de las columnas 
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_TCO_CODIGO IS ''Código tipo de comercializacion.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_EPU_CODIGO IS ''Codigo estado publicacion.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_EPV_CODIGO IS ''Código estado publicacion venta''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_TPU_V_CODIGO IS ''Código tipo publicacion venta''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.APU_CHECK_PUBLICAR_V IS ''Indicador check publicar venta''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.APU_CHECK_OCULTAR_V IS ''Indicador check ocultar venta''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.APU_CHECK_OCULT_PRECIO_V IS ''Indicador check ocultar sin precio venta''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.APU_CHECK_PUB_SIN_PRECIO_V IS ''Indicador check publicar sin precio venta.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_MTO_V_CODIGO IS ''Codigo motivo ocultacion venta''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.MTO_OCULTACION_V IS ''Descripcion motivo ocultacion venta.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_EPA_CODIGO IS ''Código estado publicacion alquiler.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_TPU_A_CODIGO IS ''Código tipo publicacion alquiler.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.APU_CHECK_PUBLICAR_A IS ''Indicador check publicar alquiler.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.APU_CHECK_OCULTAR_A IS ''Indicador check ocultar alquiler.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.APU_CHECK_OCULT_PRECIO_A IS ''Indicador check ocultar precio alquiler.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.APU_CHECK_PUB_SIN_PRECIO_A IS ''Indicador check publicar sin precio alquiler.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.DD_MTO_A_CODIGO IS ''Codigo motivo ocultacion alquiler.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.MTO_OCULTACION_A IS ''Descripcion motivo ocultacion alquiler.''';
	
	
	
	
	-- Creamos comentario tabla	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado.');
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... OK');
	
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
