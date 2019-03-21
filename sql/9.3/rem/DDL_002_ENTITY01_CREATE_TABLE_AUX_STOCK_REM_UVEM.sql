--/*
--##########################################
--## AUTOR=Sergio Hernández
--## FECHA_CREACION=20190318
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-5431
--## PRODUCTO=NO
--## Finalidad: Interfax Stock REM - UVEM
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'APR_AUX_STOCK_GEST_REM_TO_UVEM'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= 'Tabla auxiliar para almacenar la información para Gestorias de stock activos procedentes de BD REM.'; -- Vble. para los comentarios de las tablas

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
--------    APR_ID              NUMBER(9) NOT NULL, 
        PVE_GESTORIA_ID             VARCHAR2(16 CHAR),
        ACTIVO_ID                   VARCHAR2(16 CHAR),
        ACTIVO_PROPIETARIO_ID       VARCHAR2(16 CHAR),
        TPA_CODIGO                  VARCHAR2(20 CHAR),
        SAC_CODIGO                  VARCHAR2(20 CHAR),
        TVI_CODIGO                  VARCHAR2(20 CHAR),
        BIE_LOC_NOMBRE_VIA          VARCHAR2(100 CHAR),
        BIE_LOC_NUMERO_DOMICILIO    VARCHAR2(10 CHAR),
        BIE_LOC_ESCALERA            VARCHAR2(10 CHAR),
        BIE_LOC_PISO                VARCHAR2(10 CHAR),
        BIE_LOC_PUERTA              VARCHAR2(10 CHAR),
        BIE_LOC_PROVINCIA           VARCHAR2(20 CHAR),
        BIE_LOC_MUNICIPIO           VARCHAR2(20 CHAR),
        UPO_CODIGO                  VARCHAR2(20 CHAR),
        BIE_LOC_COD_POST            VARCHAR2(20 CHAR),
        BIE_LOC_POBLACION           VARCHAR2(20 CHAR),
        BIE_DREG_NUM_REGISTRO       VARCHAR2(50 CHAR),
        BIE_DREG_NUM_FINCA          VARCHAR2(50 CHAR),
        REG_IDUFIR                  VARCHAR2(50 CHAR),
        BIE_DREG_FOLIO              VARCHAR2(50 CHAR),
        BIE_DREG_LIBRO              VARCHAR2(50 CHAR),
        BIE_DREG_TOMO               VARCHAR2(50 CHAR),
        BIE_DREG_SUPERFICIE_CONSTRUIDA  VARCHAR2(16 CHAR),
        REG_SUPERFICIE_UTIL         VARCHAR2(16 CHAR),          
        REG_SUPERFICIE_ELEM_COMUN   VARCHAR2(16 CHAR),
        REG_SUPERFICIE_PARCELA      VARCHAR2(16 CHAR),
        TTA_CODIGO                  VARCHAR2(20 CHAR),
        STA_CODIGO                  VARCHAR2(20 CHAR),
        ADN_FECHA_TITULO            VARCHAR2(8 CHAR),
        PVE_NOMBRE_NOTARIO          VARCHAR2(250 CHAR),
        ADN_NUM_REFERENCIA          VARCHAR2(50 CHAR),
        AJD_FECHA_ADJUDICACION      VARCHAR2(8 CHAR),
        AJD_FECHA_DECRETO_FIRME     VARCHAR2(8 CHAR),
        JUZ_CODIGO                  VARCHAR2(20 CHAR),
        AJD_NUM_AUTO                VARCHAR2(50 CHAR),
        AJD_ID_ASUNTO               VARCHAR2(16 CHAR),
        AJD_PROCURADOR              VARCHAR2(100 CHAR),
        AJD_LETRADO                 VARCHAR2(100 CHAR),
        ETI_CODIGO                  VARCHAR2(20 CHAR),
        TIT_FECHA_INSC_REG          VARCHAR2(8 CHAR),
        PRO_NOMBRE                  VARCHAR2(100 CHAR),
        PRO_DOCIDENTIF              VARCHAR2(20 CHAR),
        PAC_PORC_PROPIEDAD          VARCHAR2(5 CHAR),
        TGP_CODIGO                  VARCHAR2(20 CHAR),
        CAT_REF_CATASTRAL           VARCHAR2(50 CHAR),
        ADO_FECHA_SOLICITUD_CEDULA  VARCHAR2(8 CHAR),
        ADO_FECHA_EMISION_CEDULA    VARCHAR2(8 CHAR),
        ACT_VPO                     VARCHAR2(1 CHAR),
        TVP_CODIGO                  VARCHAR2(20 CHAR),
        ADM_DESCALIFICADO           VARCHAR2(1 CHAR),
        SPS_FECHA_TOMA_POSESION     VARCHAR2(8 CHAR),
        ACT_LLV_FECHA_RECEPCION     VARCHAR2(8 CHAR),
        SPS_OCUPADO                 VARCHAR2(1 CHAR),
        SPS_CON_TITULO              VARCHAR2(1 CHAR),
        TPO_CODIGO_POSESORIO        VARCHAR2(20 CHAR),
        SPS_FECHA_TITULO            VARCHAR2(8 CHAR),
        SPS_FECHA_VENC_TITULO       VARCHAR2(8 CHAR),
        SPS_ACC_TAPIADO             VARCHAR2(1 CHAR),
        SPS_ACC_ANTIOCUPA           VARCHAR2(1 CHAR),
        ECO_FECHA_VENTA             VARCHAR2(8),
        ECO_PRECIO_VENTA            NUMBER(16,2),
        DD_CMA_CODIGO               VARCHAR2(20 CHAR),
        DD_CRA_CODIGO               VARCHAR2(20 CHAR),
        NOMBRE_PROPIETARIO_ANT      VARCHAR2(100 CHAR),
        NIF_PROPIETARIO_ANT         VARCHAR2(20 CHAR),
        TIPO_GESTORIA               VARCHAR2(2 CHAR)
        
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

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.PVE_GESTORIA_ID IS '' Id Gestoría 9(16)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ACTIVO_ID IS '' Id activo 9(16)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TPA_CODIGO IS '' Tipo de activo X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.SAC_CODIGO IS '' Subtipo de activo X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TVI_CODIGO IS '' Tipo de vía X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIE_LOC_NOMBRE_VIA IS '' Nombre de vía X(100)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIE_LOC_ESCALERA IS '' Nº Escalera X(10)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIE_LOC_PISO IS '' Planta X(10)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIE_LOC_PUERTA IS '' Puerta X(10)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIE_LOC_PROVINCIA IS '' Provincia X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIE_LOC_MUNICIPIO IS '' Municipio X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.UPO_CODIGO IS '' Unidad inferior al municipio X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIE_LOC_COD_POST IS '' Código postal X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIE_LOC_POBLACION IS '' Población del registro X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIE_DREG_NUM_REGISTRO IS '' Nº de registro X(50)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIE_DREG_NUM_FINCA IS '' Nº Finca X(50)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.REG_IDUFIR IS '' IDUFIR / CRU X(50)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIE_DREG_FOLIO IS '' Folio X(50)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIE_DREG_LIBRO IS '' Libro X(50)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIE_DREG_TOMO IS '' Tomo X(50)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.BIE_DREG_SUPERFICIE_CONSTRUIDA IS '' Superficie construida 9(14)V99''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.REG_SUPERFICIE_UTIL IS '' Superficie útil 9(14)V99''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.REG_SUPERFICIE_ELEM_COMUN IS '' Superficie construida con r.e.c. 9(14)V99''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.REG_SUPERFICIE_PARCELA IS '' Superficie parcela (incluida la ocupada por la edificación) 9(14)V99''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TTA_CODIGO IS '' Origen del activo (tipo de título) X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ADN_FECHA_TITULO IS '' Fecha título X(8)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.PVE_NOMBRE_NOTARIO IS '' Notario X(250)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ADN_NUM_REFERENCIA IS '' Nº protocolo X(50)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.AJD_FECHA_ADJUDICACION IS '' Fecha auto adjudicación X(8)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.AJD_FECHA_DECRETO_FIRME IS '' Fecha firmeza auto adjudicación X(8)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.JUZ_CODIGO IS '' Tipo de juzgado X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.AJD_NUM_AUTO IS '' Nº autos X(50)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.AJD_ID_ASUNTO IS '' ID asunto Recovery 9(16)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.AJD_PROCURADOR IS '' Procurador X(100)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.AJD_LETRADO IS '' Letrado X(100)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ETI_CODIGO IS '' Situación del título   X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TIT_FECHA_INSC_REG IS '' Fecha inscripción X(8)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.PRO_NOMBRE IS '' Nombre propietario X(100)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.PRO_DOCIDENTIF IS '' NIF propietario X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.PAC_PORC_PROPIEDAD IS '' % propiedad 9(3)V99''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TGP_CODIGO IS '' Grado de propiedad X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.CAT_REF_CATASTRAL IS '' Referencia catastral X(50)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ADO_FECHA_SOLICITUD_CEDULA IS '' Fecha solicitud Cédula Habitabilidad X(8)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ADO_FECHA_EMISION_CEDULA IS '' Fecha emisión Cédula Habitabilidad X(8)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ACT_VPO IS '' VPO 9''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TVP_CODIGO IS '' Régimen de protección X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ADM_DESCALIFICADO IS '' Descalificada   9''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.SPS_FECHA_TOMA_POSESION IS '' Fecha toma posesión inicial X(8)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ACT_LLV_FECHA_RECEPCION IS '' Fecha recepción llaves por Haya X(8)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.SPS_OCUPADO IS '' Ocupado 9''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.SPS_CON_TITULO IS '' Con título 9''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TPO_CODIGO_POSESORIO IS '' Título posesorio X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.SPS_FECHA_TITULO IS '' Fecha título posesorio X(8)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.SPS_FECHA_VENC_TITULO IS '' Fecha vencimiento título posesorio  X(8)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.SPS_ACC_TAPIADO IS '' Tapiado 9''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.SPS_ACC_ANTIOCUPA IS '' Puerta antiocupa 9''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ECO_FECHA_VENTA IS '' Fecha de venta X(8)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.ECO_PRECIO_VENTA IS '' Precio de venta 9(14)V99''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.NOMBRE_PROPIETARIO_ANT IS '' Nombre propietario anterior X(100)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.NIF_PROPIETARIO_ANT IS '' NIF propietario anterior X(20)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TEXT_TABLA||'.TIPO_GESTORIA IS '' 01 Administracion, 02 Plusvalia, 03 Postventa''';
    
    

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
