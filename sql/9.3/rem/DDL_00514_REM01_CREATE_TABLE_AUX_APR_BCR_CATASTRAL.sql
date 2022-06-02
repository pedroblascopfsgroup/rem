--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20220404
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17515
--## PRODUCTO=NO
--## Finalidad: Interfax Stock REM 
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'AUX_APR_BCR_CATASTRAL'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= ''; -- Vble. para los comentarios de las tablas

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
        NUM_PARCELA                     VARCHAR2(8 CHAR),
        NUM_CARTILLA_EVALUATORIA        VARCHAR2(40 CHAR),
        ORIGEN_DATOS_CATASTRALES        VARCHAR2(2 CHAR),
        CLASE_USO_CATASTRAL             VARCHAR2(2 CHAR),
        VIGENTE                         VARCHAR2(1 CHAR),
        VALOR_CATASTRAL                 VARCHAR2(15 CHAR),
        VALOR_CONSTRUCCION              VARCHAR2(15 CHAR),
        VALOR_SUELO                     VARCHAR2(15 CHAR),
        MONEDA                          VARCHAR2(5 CHAR)




        
    )
    LOGGING 
    NOCOMPRESS 
    NOCACHE
    NOPARALLEL
    NOMONITORING
    ';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
    

    
    -- Creamos comentario   
    V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
    
    
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.NUM_PARCELA IS '' Número identificativo del Prinmueble/Inmueble/superficie inmobiliaria''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.NUM_CARTILLA_EVALUATORIA IS '' Número de referencia catastral''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ORIGEN_DATOS_CATASTRALES IS '' Origen de los datos catastrales''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CLASE_USO_CATASTRAL IS '' Clase de uso catrastal'''; 
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.VIGENTE IS '' Indicador de si está vigente o no''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.VALOR_CATASTRAL IS '' Valor catastral''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.VALOR_CONSTRUCCION IS '' Valor de construcción''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.VALOR_SUELO IS '' Valor del suelo''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.MONEDA IS '' Moneda''';
    
    
   


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
