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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'AUX_APR_ATRIBUTOS_LEGALES'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Auxiliar atributos legales'; -- Vble. para los comentarios de las tablas

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
        TREGISTRO	VARCHAR2(2 CHAR) DEFAULT ''4'',
        ZZEXTERNALID	VARCHAR2(20 CHAR),
        ZZ_CALIFENERG	VARCHAR2(1 CHAR),
        ZZ_CERTREGISTRADO	VARCHAR2(2 CHAR),
        ZZ_FECSOL	VARCHAR2(8 CHAR),
        ZZ_FECFINVIG	VARCHAR2(8 CHAR),
        ZZ_LISTEMIIS	VARCHAR2(2 CHAR),
        ZZ_VALEMISNS	VARCHAR2(11 CHAR),
        ZZ_LISTENEERG	VARCHAR2(2 CHAR),
        ZZ_VALENERG	VARCHAR2(11 CHAR),
        ZZSITUACIONCEE	VARCHAR2 (2 CHAR),
        ZZNUMCEE	VARCHAR2(10 CHAR),
        ZZMOTEXONERACIONCEE	VARCHAR2 (2 CHAR),
        ZZINCIDENCIACEE	VARCHAR2 (2 CHAR),
        ZZCODIGOSST	VARCHAR2(10 CHAR),
        ZZ_NUMEXPED	VARCHAR2(30 CHAR),
        ZZPLANVPO	VARCHAR2(4 CHAR),
        ZZPLANVPODESCRIPCION	VARCHAR2(80 CHAR),
        ZZREGIMENTRANSMISION	VARCHAR2(4 CHAR),
        ZZFECHAPROTECCIONINICIO	VARCHAR2(8 CHAR),
        ZZFECHAPROTECCIONFIN	VARCHAR2(8 CHAR),
        ZZFECHAPROHIBICDISPOFIN	VARCHAR2(8 CHAR),
        ZZESTADOESTUDIOINICIAL	VARCHAR2(4 CHAR),
        ZZ_CEDHABIT	VARCHAR2(2 CHAR)

        
    )';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Tabla creada.');
    

    
    -- Creamos comentario   
    V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TEXT_TABLA||' IS '''||V_COMMENT_TABLE||'''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... Comentario creado.');
    
    
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TEXT_TABLA||'... OK');

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TREGISTRO IS '' Tipo de registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZEXTERNALID IS '' Objeto inmobiliario origen''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZ_CALIFENERG IS '' Calificación energética''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZ_CERTREGISTRADO IS '' Certificado de registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZ_FECSOL IS '' Fecha solicitud''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZ_FECFINVIG IS '' Fecha fin vigencia''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZ_LISTEMIIS IS '' Lista emisiones''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZ_VALEMISNS IS '' Valores''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZ_LISTENEERG IS '' Lista energía''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZ_VALENERG IS '' Valor energía''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZSITUACIONCEE IS '' Situación CEE''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZNUMCEE IS '' Nº CEE''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZMOTEXONERACIONCEE IS '' Motivo exoneración CEE''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZINCIDENCIACEE IS '' Incidencia CEE''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZCODIGOSST IS '' Código SST''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZ_NUMEXPED IS '' Número de expediente''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZPLANVPO IS '' Plan V.P.O.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZPLANVPODESCRIPCION IS '' Descripción plan''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZREGIMENTRANSMISION IS '' Régimen transmisión''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZFECHAPROTECCIONINICIO IS '' Fecha inicio protección''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZFECHAPROTECCIONFIN IS '' Fecha fin protección''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZFECHAPROHIBICDISPOFIN IS '' Fecha fin prohibición disponer''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZESTADOESTUDIOINICIAL IS '' Estado estudio inicial''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ZZ_CEDHABIT	 IS '' Cédula habitabilidad''';


   
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
