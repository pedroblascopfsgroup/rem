--/*
--##########################################
--## AUTOR=JOSE VILLEL
--## FECHA_CREACION=20160810
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=0
--## PRODUCTO=NO
--## Finalidad: Tabla para gestionar los condicionantes de un expediente comercial
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'COE_CONDICIONANTES_EXPEDIENTE'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla para gestionar los condicionantes de un expediente comercial'; -- Vble. para los comentarios de las tablas

    
    
    
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
	V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_COE_CONDICIONANTES_EXPEDIENTE'' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_COE_CONDICIONANTES_EXPEDIENTE... Ya existe. Se borrará.');  
		EXECUTE IMMEDIATE 'DROP SEQUENCE '||V_ESQUEMA||'.S_COE_CONDICIONANTES_EXPEDIENTE';
		
	END IF;

	
	
	-- Creamos la tabla
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
	V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
	(
			COE_ID           						NUMBER(16,0)                NOT NULL,
			ECO_ID									NUMBER(16,0)                NOT NULL,
			COE_SOLICITA_FINANCIACION				NUMBER(1)    				DEFAULT 0 NOT NULL ENABLE,
			COE_ENTIDAD_FINANCIACION-AJENA			VARCHAR2(50 CHAR),
			DD_TCC_ID								NUMBER(16),
			COE_PORCENTAJE_RESERVA					NUMBER(16,2),
			COE_PLAZO_FIRMA_RESERVA					NUMBER(16)
			COE_IMPORTE_RESERVA						NUMBER(16,2),
			DD_TIT_ID								NUMBER16),
			COE_TIPO_APLICABLE						NUMBER(16,2),
			COE_RENUNCIA_EXENCION					NUMBER(1),
			COE_RESERVA_CON_IMPUESTO				NUMBER(1),
			COE_GASTOS_PLUSVALIA					NUMBER(16,2),
			DD_TPC_ID_PLUSVALIA						NUMBER(16,0),					
			COE_GASTOS_NOTARIA						NUMBER(16,2),
			DD_TPC_ID_NOTARIA						NUMBER(16,0),
			COE_GASTOS_OTROS						NUMBER(16,2),
			DD_TPC_ID_GASTOS_OTROS					NUMBER(16,0),
			COE_FECHA_ACTUALIZACION_CARGAS			DATE,
			COE_CARGAS_IMPUESTOS					NUMBER(16,2),
			DD_TPC_ID_IMPUESTOS						NUMBER(16,0),
			COE_CARGAS_COMUNIDAD					NUMBER(16,2),
			DD_TPC_ID_COMUNIDAD						NUMBER(16,0),
			COE_CARGAS_OTROS						NUMBER(16,2),
			DD_TPC_ID_CARGAS_OTROS					NUMBER(16,0),
			COE_SUJETO_TANTEO_RETRACTO				NUMBER(1),
			COE_RENUNCIA_SANEAMIENTO_EVICCION		NUMBER(1),
			COE_RENUNCIA_SANEAMIENTO_VICIOS			NUMBER(1),
			COE_VPO									NUMBER(1),
			COE_LICENCIA							NUMBER(1),
			DD_TPC_ID_LICENCIA						NUMBER(16,0),
			COE_PROCEDE_DESCALIFICACION				NUMBER(1),
			DD_TPC_ID_DESCALIFICACION				NUMBER(16,0),			
			VERSION 								NUMBER(38,0) 				DEFAULT 0 NOT NULL ENABLE, 
			USUARIOCREAR 							VARCHAR2(50 CHAR) 			NOT NULL ENABLE, 
			FECHACREAR 								TIMESTAMP (6) 				NOT NULL ENABLE, 
			USUARIOMODIFICAR 						VARCHAR2(50 CHAR), 
			FECHAMODIFICAR 							TIMESTAMP (6), 
			USUARIOBORRAR 							VARCHAR2(50 CHAR), 
			FECHABORRAR 							TIMESTAMP (6), 
			BORRADO 								NUMBER(1,0) 				DEFAULT 0 NOT NULL ENABLE			
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
	V_MSQL := 'CREATE UNIQUE INDEX '||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK ON '||V_ESQUEMA|| '.'||V_TEXT_TABLA||'(COE_ID) TABLESPACE '||V_TABLESPACE_IDX;		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... Indice creado.');	
	
	-- Creamos primary key
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT '||V_TEXT_TABLA||'_PK PRIMARY KEY (COE_ID) USING INDEX)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'_PK... PK creada.');	
	
		-- Creamos foreign key ECO_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_COE_ECO_ID FOREIGN KEY (ECO_ID) REFERENCES '||V_ESQUEMA||'.ECO_EXPEDIENTE_COMERCIAL (ECO_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_COE_ECO_ID... Foreign key creada.');
	
		-- Creamos foreign key DD_TCC_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_COE_TCC_ID FOREIGN KEY (DD_TCC_ID) REFERENCES '||V_ESQUEMA||'.DD_TCC_TIPO_CALCULO (DD_TCC_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_COE_TCC_ID... Foreign key creada.');
	
			-- Creamos foreign key DD_TIT_ID
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_COE_TIT_ID FOREIGN KEY (DD_TIT_ID) REFERENCES '||V_ESQUEMA||'.DD_TIT_TIPOS_IMPUESTO (DD_TIT_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_COE_TIT_ID... Foreign key creada.');
	
				-- Creamos foreign key DD_TPC_ID_PLUSVALIA
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_COE_TPC_ID_PLUSVALIA FOREIGN KEY (DD_TPC_ID_PLUSVALIA) REFERENCES '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA (DD_TPC_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_COE_TPC_ID_PLUSVALIA... Foreign key creada.');
	
					-- Creamos foreign key DD_TPC_ID_NOTARIA
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_COE_TPC_ID_NOTARIA FOREIGN KEY (DD_TPC_ID_NOTARIA) REFERENCES '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA (DD_TPC_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_COE_TPC_ID_NOTARIA... Foreign key creada.');
	
					-- Creamos foreign key DD_TPC_ID_GASTOS_OTROS
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_COE_TPC_GASTOS_OTROS FOREIGN KEY (DD_TPC_ID_GASTOS_OTROS) REFERENCES '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA (DD_TPC_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_COE_TPC_GASTOS_OTROS... Foreign key creada.');
	
					-- Creamos foreign key DD_TPC_ID_IMPUESTOS
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_COE_TPC_ID_IMPUESTOS FOREIGN KEY (DD_TPC_ID_IMPUESTOS) REFERENCES '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA (DD_TPC_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_COE_TPC_ID_IMPUESTOS... Foreign key creada.');
	
					-- Creamos foreign key DD_TPC_ID_COMUNIDAD
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_COE_TPC_ID_COMUNIDAD FOREIGN KEY (DD_TPC_ID_COMUNIDAD) REFERENCES '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA (DD_TPC_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_COE_TPC_ID_COMUNIDAD... Foreign key creada.');
	
					-- Creamos foreign key DD_TPC_ID_CARGAS_OTROS
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_COE_TPC_CARGAS_OTROS FOREIGN KEY (DD_TPC_ID_CARGAS_OTROS) REFERENCES '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA (DD_TPC_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_COE_TPC_CARGAS_OTROS... Foreign key creada.');
	
						-- Creamos foreign key 	DD_TPC_ID_LICENCIA
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_COE_TPC_LICENCIA FOREIGN KEY (DD_TPC_ID_LICENCIA) REFERENCES '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA (DD_TPC_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_COE_TPC_LICENCIA... Foreign key creada.');
	
						-- Creamos foreign key 	DD_TPC_ID_DESCALIFICACION
	V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' ADD (CONSTRAINT FK_COE_TPC_DESCALIFICACION FOREIGN KEY (DD_TPC_ID_DESCALIFICACION) REFERENCES '||V_ESQUEMA||'.DD_TPC_TIPOS_PORCUENTA (DD_TPC_ID) ON DELETE SET NULL)';
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.FK_COE_TPC_DESCALIFICACION... Foreign key creada.');
	
	
	

	-- Creamos sequence
	V_MSQL := 'CREATE SEQUENCE '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'';		
	EXECUTE IMMEDIATE V_MSQL;		
	DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.S_'||V_TEXT_TABLA||'... Secuencia creada');
		
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
	
	
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

EXIT