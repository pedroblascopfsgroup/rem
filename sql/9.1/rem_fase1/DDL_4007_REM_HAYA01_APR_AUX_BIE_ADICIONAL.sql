--/*
--##########################################
--## AUTOR=ANAHUAC DE VICENTE
--## FECHA_CREACION=20160301
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla auxiliar para el aprovisionamiento de la información adicional de los bienes de recovery-HAYA.
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_BIE_ADICIONAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla auxiliar para el aprovisionamiento de la información adicional de los bienes de recovery-HAYA.'; -- Vble. para los comentarios de las tablas

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
		BIE_ADI_ID						NUMBER(16,0)			NOT NULL, 
		BIE_ID							NUMBER(16,0)			NOT NULL, 
		BIE_ADI_NOM_EMPRESA				VARCHAR2(150 CHAR),
		BIE_ADI_CIF_EMPRESA				VARCHAR2(20 CHAR),
		BIE_ADI_COD_IAE					VARCHAR2(50 CHAR),
		BIE_ADI_DES_IAE					VARCHAR2(150 CHAR),
		BIE_ADI_VALORACION				NUMBER(16,2),
		BIE_ADI_ENTIDAD					VARCHAR2(150 CHAR),
		BIE_ADI_NUM_CUENTA				VARCHAR2(150 CHAR),
		BIE_ADI_MATRICULA				VARCHAR2(50 CHAR),
		BIE_ADI_BASTIDOR				VARCHAR2(50 CHAR),
		BIE_ADI_MODELO					VARCHAR2(50 CHAR),
		BIE_ADI_MARCA					VARCHAR2(50 CHAR),
		BIE_ADI_FECHAMATRICULA			TIMESTAMP(6),		
		BIE_ADI_FFIN_REV_CARGA			DATE,
		BIE_ADI_SIN_CARGA				NUMBER(1,0),
		BIE_ADI_OBS_CARGA				VARCHAR2(250 CHAR),
		BIE_ADI_DEUDA_SEGUN_JUZ			NUMBER(16,2),
		BIE_ADI_CAN_CARGAS_RESUMEN		VARCHAR2(500 CHAR),
		BIE_ADI_CAN_CARGAS_PROPUESTA	VARCHAR2(500 CHAR),
		DD_TPB_ID						NUMBER(16,0),
		DD_TPN_ID						NUMBER(16,0),
		VERSION							NUMBER(38,0),
		USUARIOCREAR					VARCHAR2(50 CHAR),
		FECHACREAR						TIMESTAMP(6),
		USUARIOMODIFICAR				VARCHAR2(50 CHAR),
		FECHAMODIFICAR					TIMESTAMP(6),
		USUARIOBORRAR					VARCHAR2(50 CHAR),
		FECHABORRAR						TIMESTAMP(6),
		BORRADO							NUMBER(1,0)
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
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(BIE_ADI_ID) TABLESPACE '||V_TABLESPACE_IDX;			
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Indice creado.');
	
	
	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (BIE_ADI_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');
	
	
	-- Creamos foreign key FK_APRBIEADI_APRBIEN
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_APRBIEADI_APRBIEN FOREIGN KEY (BIE_ID) REFERENCES '||V_ESQUEMA||'.APR_AUX_BIE_BIEN (BIE_ID) ON DELETE CASCADE)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_APRBIEADI_APRBIEN... Foreign key creada.');
	
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