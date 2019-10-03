--/*
--##########################################
--## AUTOR=Ivan Rubio
--## FECHA_CREACION=20190717
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-7106
--## PRODUCTO=NO
--##
--## Finalidad: DDL Creación de la tabla ACT_PLS_PLUSVALIA
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    V_TABLA VARCHAR2(150 CHAR):= 'ACT_PLS_PLUSVALIA'; -- Vble. con el nombre de la tabla.
    V_PK VARCHAR2(20 CHAR):= 'PK_ACT_PLS_ID'; -- Vble. con el nombre de la clave primaria.
    V_FK VARCHAR2(20 CHAR):= 'ACT_PLS_FK'; -- Vble. con el prefijo de las claves ajenas.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    -- ******** ACT_PLS_PLUSVALIA *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla ACT_PLS_PLUSVALIA
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TABLA||'... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
               (ACT_PLS_ID NUMBER (16,0) 
				  , ACT_ID NUMBER (16,0) NOT NULL ENABLE 
				  , ACT_PLS_FECHA_RECEPCION_PLUSVALIA DATE NOT NULL ENABLE
				  , ACT_PLS_FECHA_PRESENTACION_PLUSVALIA DATE NOT NULL ENABLE
				  , ACT_PLS_FECHA_PRESENTACION_RECURSO DATE NOT NULL ENABLE
				  , ACT_PLS_FECHA_RESPUESTA_RECURSO DATE NOT NULL ENABLE
				  , ACT_PLS_APERTURA_Y_SEGUIMIENTO_EXP NUMBER (16,0) NOT NULL ENABLE
				  , ACT_PLS_IMPORTE_PAGADO NUMBER (16,2) NOT NULL ENABLE
				  , ACT_PLS_EXENTO NUMBER (16,0) NOT NULL ENABLE
				  , ACT_PLS_AUTOLIQUIDACION NUMBER (16,0) NOT NULL ENABLE
				  , ACT_PLS_OBSERVACIONES VARCHAR2(4000 CHAR)
				  , GPV_ID NUMBER(16,0)
				  , ACT_PLS_MINUSVALIA NUMBER(16,0) NOT NULL ENABLE
				  , VERSION NUMBER(16,0) DEFAULT 0
				  , USUARIOCREAR VARCHAR2 (50 CHAR) 
				  , FECHACREAR TIMESTAMP(6) DEFAULT SYSTIMESTAMP
				  , USUARIOMODIFICAR VARCHAR2 (50 CHAR) 
				  , FECHAMODIFICAR TIMESTAMP(6)
				  , USUARIOBORRAR VARCHAR2 (50 CHAR)
				  , FECHABORRAR TIMESTAMP(6)
				  , BORRADO NUMBER(1,0) DEFAULT 0
				  , CONSTRAINT '||V_PK||' PRIMARY KEY(ACT_PLS_ID)
				  , CONSTRAINT '||V_FK||'_ACT_ID FOREIGN KEY (ACT_ID) REFERENCES '||V_ESQUEMA||'.ACT_ACTIVO (ACT_ID) ON DELETE SET NULL
				  , CONSTRAINT '||V_FK||'_APERTURA_Y_SEGUIMIENTO_EXP FOREIGN KEY (ACT_PLS_APERTURA_Y_SEGUIMIENTO_EXP) REFERENCES '||V_ESQUEMA_M||'.DD_SIN_SINO (DD_SIN_ID) ON DELETE SET NULL
				  , CONSTRAINT '||V_FK||'_GPV_ID FOREIGN KEY (GPV_ID) REFERENCES '||V_ESQUEMA||'.GPV_GASTOS_PROVEEDOR (GPV_ID) ON DELETE SET NULL
				  , CONSTRAINT '||V_FK||'_MINUSVALIA FOREIGN KEY (ACT_PLS_MINUSVALIA) REFERENCES '||V_ESQUEMA_M||'.DD_SIN_SINO (DD_SIN_ID) ON DELETE SET NULL
				  , CONSTRAINT '||V_FK||'_EXENTO FOREIGN KEY (ACT_PLS_EXENTO) REFERENCES '||V_ESQUEMA_M||'.DD_SIN_SINO (DD_SIN_ID) ON DELETE SET NULL
				  , CONSTRAINT '||V_FK||'_AUTOLIQUIDACION FOREIGN KEY (ACT_PLS_AUTOLIQUIDACION) REFERENCES '||V_ESQUEMA_M||'.DD_SIN_SINO (DD_SIN_ID) ON DELETE SET NULL
			  )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TABLA||'... Tabla creada');
		
		
    END IF;
    
    -- Creamos la secuencia
    
    V_SQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = ''S_'||V_TABLA||''' and SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
	EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS; 
	IF V_NUM_TABLAS = 1 THEN
		DBMS_OUTPUT.PUT_LINE('[INFO] '|| V_ESQUEMA ||'.S_'||V_TABLA||'... Ya existe.');  
    ELSE
  		execute immediate 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_'||V_TABLA||'  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_'||V_TABLA||'... Secuencia creada correctamente.');
	END IF;
	
	-- Creamos comentario	
	V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TABLA||' IS ''Tabla para gestionar las plusvalías.''';		
	EXECUTE IMMEDIATE V_MSQL;
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentario creado sobre la tabla.');

	-- Comentarios sobre las columnas
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_PLS_ID IS ''Código identificador único de plusvalía.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_ID IS ''Código identificador de activo.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_PLS_FECHA_RECEPCION_PLUSVALIA IS ''Fecha de recepción de la plusvalía.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_PLS_FECHA_PRESENTACION_PLUSVALIA IS ''Fecha de pago/presentación de la plusvalía.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_PLS_FECHA_PRESENTACION_RECURSO IS ''Fecha de presentación del recurso.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_PLS_FECHA_RESPUESTA_RECURSO IS ''Fecha de respuesta del recurso.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_PLS_APERTURA_Y_SEGUIMIENTO_EXP IS ''Apertura de expediente de recurso extrajudicial y seguimiento del mismo. (Sí/No)''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_PLS_IMPORTE_PAGADO IS ''Importe pagado plusvalía''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_PLS_EXENTO IS ''Exento (Si/No)''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_PLS_AUTOLIQUIDACION IS ''Autoliquidación (Si/No)''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_PLS_OBSERVACIONES IS ''Observaciones''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.GPV_ID IS ''Id de gasto asociado.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.ACT_PLS_MINUSVALIA IS ''Minusvalía (Si/No)''';
	
	-- Comentarios auditoría
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.VERSION IS ''Versión del registro.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOCREAR IS ''Indica el usuario que creó el registro.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHACREAR IS ''Indica la fecha en la que se creó el registro.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOMODIFICAR IS ''Indica el usuario que modificó el registro.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHAMODIFICAR IS ''Indica la fecha en la que se modificó el registro.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.USUARIOBORRAR IS ''Indica el usuario que borró el registro.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.FECHABORRAR IS ''Indica la fecha en la que se borró el registro.''';
	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.BORRADO IS ''Indicador de borrado.''';
	
	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TABLA||'... Comentarios creados sobre las columnas de la tabla.');
		
    
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
