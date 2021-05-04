--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20210503
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-13784
--## PRODUCTO=NO
--## Finalidad: Creación diccionario ESPARTA_EXCEL5
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
    V_TEXT_TABLA VARCHAR2(150 CHAR):= 'ESPARTA_EXCEL5'; -- Vble. con el nombre de la tabla.
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

BEGIN

    -- ******** DD_TPG_TPO_DOC_GASTO_ASOC *******
    DBMS_OUTPUT.PUT_LINE('******** '||V_TEXT_TABLA||' ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comprobaciones previas'); 
    
    -- Creacion Tabla DD_TPG_TPO_DOC_GASTO_ASOC
    
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TEXT_TABLA||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;

	-- Si no existe la tabla se crea
	IF V_NUM_TABLAS = 1 THEN 
			    
	-- Verificar si la tabla ya existe
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Ya existe. Se borrará.');
		EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' CASCADE CONSTRAINTS';
	END IF;
        --Creamos la tabla
        DBMS_OUTPUT.PUT_LINE('[CREAMOS '||V_TEXT_TABLA||']');
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' (
			ACT_NUM_ACTIVO               NUMBER(16,0) NOT NULL
			, CAMPO                      VARCHAR2(3500 CHAR)
			, VALOR_ACTUAL               VARCHAR2(3500 CHAR)
			, VALOR_NUEVO                VARCHAR2(3500 CHAR)
			, DESCRIPCION                VARCHAR2(3500 CHAR)
			  )';        	

		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TEXT_TABLA||'... Tabla creada');
 
        EXECUTE IMMEDIATE 'COMMENT ON TABLE  ' || V_ESQUEMA || '.ESPARTA_EXCEL5 IS ''Tabla para crear el reporte de perímetros''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ESPARTA_EXCEL5.ACT_NUM_ACTIVO IS ''Número de activo''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ESPARTA_EXCEL5.CAMPO IS ''Nombre del campo del activo''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ESPARTA_EXCEL5.VALOR_ACTUAL IS ''Valor actual del campo del activo''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ESPARTA_EXCEL5.VALOR_NUEVO IS ''Valor nuevo del campo del activo''';
        EXECUTE IMMEDIATE 'COMMENT ON COLUMN ' || V_ESQUEMA || '.ESPARTA_EXCEL5.DESCRIPCION IS ''Descripción del activo o campo''';
    
        DBMS_OUTPUT.PUT_LINE('Creados los comentarios en TABLA '|| V_ESQUEMA ||'.ESPARTA_EXCEL5... OK');
   

COMMIT;
DBMS_OUTPUT.PUT_LINE('[INFO] COMMIT');
    
    
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
