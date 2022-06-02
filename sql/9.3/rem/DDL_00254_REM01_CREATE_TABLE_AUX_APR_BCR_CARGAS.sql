--/*
--##########################################
--## AUTOR=Alejandra García
--## FECHA_CREACION=20220216
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17162
--## PRODUCTO=NO
--## Finalidad: Interfax Stock REM 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - [HREOS-13942] - Santi Monzó
--##        0.2 Modificación campos - [HREOS-14716] - Alejandra García
--##        0.3 Añadir campos nuevos y cambiar de 15,2 a 10,2 en campo CAPITAL_PENDIENTE- [HREOS-17162] - Alejandra García
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'AUX_APR_BCR_CARGAS'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
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
        COD_PARCELA          VARCHAR2(8 CHAR),
        IDENTIF_CARGA        VARCHAR2(16 CHAR),
        TIPO_CARGA           VARCHAR2(3 CHAR),
        INTERLOCUTOR         VARCHAR2(40 CHAR),
        FEC_INI              DATE,
        CAPITAL_PENDIENTE    NUMBER(10,2),
        FEC_FIN              DATE,
        COD_ESTADO_CARGA     VARCHAR2(3 CHAR),
        BORRADO              NUMBER(1,0) DEFAULT 0,
        BIE_CAR_ID           NUMBER(16,0),
        CRG_ID               NUMBER(16,0),
        ACTUALIZA            NUMBER(1,0) DEFAULT 0,
        IND_PREFERENTE       VARCHAR2(1 CHAR),
        IND_CARGA_EJECUTADA  VARCHAR2(1 CHAR),
        IGUALDAD_RANGO       VARCHAR2(1 CHAR),
        IND_CARGA_INDEFINIDA VARCHAR2(1 CHAR),
        IND_CARGA_ECONOMICA  VARCHAR2(1 CHAR),
        ORDEN                NUMBER(4,0)




        
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

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COD_PARCELA IS '' Identificador en BC del OI''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IDENTIF_CARGA IS '' Identificador en BC de la carga''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TIPO_CARGA IS '' Tipo de carga''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.INTERLOCUTOR IS '' Descripción acreedor''';
 
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CAPITAL_PENDIENTE IS '' Importe máximo de la carga''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.FEC_FIN IS '' Fecha presentacion can. en re''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.COD_ESTADO_CARGA IS '' Código estado de la carga''';


    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IND_PREFERENTE IS '' Indicador preferente''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IND_CARGA_EJECUTADA IS '' Identificador carga ejecutada''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IGUALDAD_RANGO IS '' Igualdad de rango''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IND_CARGA_INDEFINIDA IS '' Identificador carga indefinida''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.IND_CARGA_ECONOMICA IS '' Identificador carga económica''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ORDEN IS '' Orden''';
    
   


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
