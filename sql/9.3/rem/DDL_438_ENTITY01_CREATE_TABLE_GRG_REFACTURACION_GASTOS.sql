--/*
--##########################################
--## AUTOR=ALVARO GARCIA
--## FECHA_CREACION=20190630
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-6721
--## PRODUCTO=NO
--## Finalidad: DDL Creación de la tabla GRG_REFACTURACION_GASTOS
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'GRG_REFACTURACION_GASTOS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar 
    V_COUNT_CONS NUMBER(16); -- Vble. para validar la existencia de una constraint.

BEGIN

    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe.');
    ELSE
    -- Creamos la tabla
        	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||'...');
    		V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'
                (
		    GRG_ID			NUMBER(16) NOT NULL,
                    GRG_GPV_ID                  NUMBER(16) NOT NULL,
                    GRG_GPV_ID_REFACTURADO      NUMBER(16) NOT NULL,       
                    USUARIOCREAR                VARCHAR2(50 CHAR) NOT NULL,
                    FECHACREAR                  TIMESTAMP(6) NOT NULL,
                    USUARIOMODIFICAR            VARCHAR2(50 CHAR),
                    FECHAMODIFICAR              TIMESTAMP(6),
                    USUARIOBORRAR               VARCHAR2(50 CHAR),
                    FECHABORRAR                 TIMESTAMP(6),
                    BORRADO                     NUMBER(1,0) DEFAULT 0 NOT NULL ,
                    CONSTRAINT UK_GRG_GPV_ID_REFACT_BOR UNIQUE (GRG_GPV_ID_REFACTURADO, BORRADO),
                    CONSTRAINT FK_GRG_GPV_ID FOREIGN KEY (GRG_GPV_ID) REFERENCES GPV_GASTOS_PROVEEDOR (GPV_ID),
		    CONSTRAINT FK_GRG_GPV_ID_REFACT FOREIGN KEY (GRG_GPV_ID_REFACTURADO) REFERENCES GPV_GASTOS_PROVEEDOR (GPV_ID)  
                )
                ';
    		EXECUTE IMMEDIATE V_MSQL;
    		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TCP_TAREA_CONFIG_PETICION... Tabla creada');
    		
    		V_MSQL := 'CREATE SEQUENCE ' || V_ESQUEMA || '.S_GRG_REFACTURACION_GASTOS MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 100 NOORDER  NOCYCLE';
	
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.S_GRG_REFACTURACION_GASTOS... Secuencia creada correctamente.');

    END IF;

	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.GRG_ID IS '' Id refacturacion de gasto''';
    	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.GRG_GPV_ID IS '' Id gasto''';
    	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.GRG_GPV_ID_REFACTURADO IS '' Id gasto refacturado''';
    	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.USUARIOCREAR IS '' Usuario que crea el registro''';
    	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FECHACREAR IS '' Fecha de creacion del registro''';
    	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.USUARIOMODIFICAR IS '' Usuario que modifica el registro''';
    	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FECHAMODIFICAR IS '' Fecha de modificacion del registro''';
    	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.USUARIOBORRAR IS '' Usuario que borra el registro''';
    	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FECHABORRAR IS '' Fecha de borrado del registro''';
  	EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BORRADO IS '' Borrado logico del registro''';

	DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TEXT_TABLA||' comentarios creados');

	V_SQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE CONSTRAINT_NAME=''UK_GRG_GPV_ID_BOR'' AND TABLE_NAME=''GRG_REFACTURACION_GASTOS''';
	EXECUTE IMMEDIATE V_SQL INTO V_COUNT_CONS;

	IF V_COUNT_CONS = 1 THEN 

		DBMS_OUTPUT.PUT_LINE('[INFO] UK_GRG_GPV_ID_BOR existe en la tabla GRG_REFACTURACION_GASTOS, procedemos a su eliminación');

		V_MSQL := 'ALTER TABLE ' || V_ESQUEMA || '.'||V_TEXT_TABLA||' DROP CONSTRAINT UK_GRG_GPV_ID_BOR';
		EXECUTE IMMEDIATE V_MSQL;

		DBMS_OUTPUT.PUT_LINE('[INFO] UK_GRG_GPV_ID_BOR eliminado');

	ELSE

		DBMS_OUTPUT.PUT_LINE('[INFO] UK_GRG_GPV_ID_BOR no existe');

	END IF;

        COMMIT;
    
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
