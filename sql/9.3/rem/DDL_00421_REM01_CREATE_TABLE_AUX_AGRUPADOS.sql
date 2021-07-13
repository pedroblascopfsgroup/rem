--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210705
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14507
--## PRODUCTO=NO
--## Finalidad: Interfax Stock REM 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - PIER GOTTA - [HREOS-14503]
--##        0.2 Modificar el campo FECHA_ALTA de VARCHAR2(8 CHAR) a DATE - Alejandra García - [HREOS-14507]
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'AUX_APR_BCR_CAMPANYA_AGRUP'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
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
           
        ID_AGRUPADOR                     VARCHAR2(8 CHAR),
        NOMBRE               		     VARCHAR2(100 CHAR),
        FECHA_ALTA                  	 DATE,
        TIPOLOGIA		 	             VARCHAR2(10 CHAR),
        FECHA_INICIO_CAMPANA		     DATE,
        FECHA_FIN_PREVISTA		         DATE,
        FECHA_FIN_REAL			         DATE,
        TIEMPO_COSECHA			         NUMBER(3,0),
        CAMPANA_BDC			             VARCHAR2(1 CHAR),
        NO_ANALIZAR			             VARCHAR2(1 CHAR)
        



        
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
    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.AUX_APR_BCR_CAMPANYA_AGRUP.ID_AGRUPADOR IS ''Código del agrupador''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.AUX_APR_BCR_CAMPANYA_AGRUP.NOMBRE IS ''Nombre del agrupador''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.AUX_APR_BCR_CAMPANYA_AGRUP.FECHA_ALTA IS ''Fecha de alta''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.AUX_APR_BCR_CAMPANYA_AGRUP.TIPOLOGIA IS ''Tipología de la Campaña''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.AUX_APR_BCR_CAMPANYA_AGRUP.FECHA_INICIO_CAMPANA IS ''Fecha inicio prevista''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.AUX_APR_BCR_CAMPANYA_AGRUP.FECHA_FIN_PREVISTA IS ''Fecha fin prevista''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.AUX_APR_BCR_CAMPANYA_AGRUP.FECHA_FIN_REAL IS ''Fecha fin real''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.AUX_APR_BCR_CAMPANYA_AGRUP.TIEMPO_COSECHA IS ''Tiempo cosecha''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
    V_MSQL := 'COMMENT ON COLUMN ' || V_ESQUEMA || '.AUX_APR_BCR_CAMPANYA_AGRUP.CAMPANA_BDC IS ''Tipo de campaña''';       
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
