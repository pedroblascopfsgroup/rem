--/*
--##########################################
--## AUTOR=Santi Monzó
--## FECHA_CREACION=20220629
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-18224
--## PRODUCTO=NO
--## Finalidad:
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'AUX_APR_DATOS_POSESION'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Auxiliar datos de posesion'; -- Vble. para los comentarios de las tablas

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
        TREGISTRO	VARCHAR2(2 CHAR) DEFAULT ''5'',
        ZZEXTERNALID	VARCHAR2(20 CHAR),
        ZZFE1APOS	VARCHAR2(8 CHAR),
        ZZFECHAPREVLANZ	VARCHAR2(8 CHAR),
        ZZFECHALANZ	VARCHAR2(8 CHAR),
        ZZFERESMOR	VARCHAR2(8 CHAR),
        ZZMOTISUSP	VARCHAR2(2 CHAR),
        ZZFOROBTPOS	VARCHAR2(2 CHAR)

        
    )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
    

    
    -- Creamos comentario   
    V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
    
    
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TREGISTRO IS '' Tipo de registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZEXTERNALID	 IS '' Objeto inmobiliario origen''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZFE1APOS IS '' Fecha primera posesión''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZFECHAPREVLANZ IS '' Fecha prevista de lanzamiento''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZFECHALANZ IS '' Fecha de lanzamiento''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZFERESMOR IS '' Fecha de resolución''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZMOTISUSP IS '' Motivo suspensión''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZFOROBTPOS IS '' Forma obtención posesión''';


   
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
