--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20220317
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-17367
--## PRODUCTO=NO
--## Finalidad: Interfax Stock REM 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - HREOS-13942 - Santi Monzó
--##        0.2 Versión inicial - HREOS-14162 - Alejandra García - Añadir campos
--##        0.3  HREOS-14199 -  Santi Monzó - Añadir array ara que cree las 4 tablas, añadir campo FLAG_EN_REM en las BCR
--##        0.4  HREOS-14271 -  Alejandra García - Añadir campo PROMO_COMERCIAL y aumentar tamaño a X_GOOGLE e Y_GOOGLE
--##        0.5  HREOS-14344 -  Alejandra García - Añadir campo SOCIEDAD_PATRIOMONIAL
--##        0.6  HREOS-14370 -  Alejandra García - Añadir campo FLAG_FICHEROS
--##        0.7  HREOS-14533 -  Daniel Algaba - Se cambia la longitud de los campos COD_GESTORIA y COD_REGISTRO_PROPIEDAD
--##        0.7  HREOS-14545 -  Daniel Algaba - Se cambia la longitud de los campos COD_GESTORIA y COD_GESTORIA_ADMINIS
--##        0.8  HREOS-14545 -  Daniel Algaba - Se hace un repaso completo, se añaden campos y se cambian algunas longitudes
--##        0.9  HREOS-14545 -  Daniel Algaba - Se cambia la longitud de BANCO_ORIGEN A 4
--##        0.10  HREOS-14648 -  Daniel Algaba - Se cambia la longitud de CARTERA_VENTA_ACTIVOS y CARTERA_VENTA_CREDITOS A 4
--##        0.11  HREOS-14838 -  Daniel Algaba - Nuevos campos ORIGEN_REGULATORIO, TXT_COMERCIAL_CAS y TXT_COMERCIAL_ENG
--##        0.12  HREOS-XXXXX -  Alejandra García - Cambiar longitud al campo MOT_NECESIDAD_ARRAS
--##        0.13  HREOS-16321 -  Daniel Algaba - Añadimos flag de oferta viva
--##        0.14  HREOS-17147 -  Alejandra García - Añadir nuevos campos para mejora del proceso stock
--##        0.15  HREOS-17348 -  Daniel Algaba - Añadir nuevos campos informe comercial
--##        0.16  HREOS-17367 -  Daniel Algaba - Añadir nuevos campos
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'AUX_APR_BCR_STOCK'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= ''; -- Vble. para los comentarios de las tablas
   


  TYPE T_COL IS TABLE OF VARCHAR2(500 CHAR);
  TYPE T_ARRAY_COL IS TABLE OF T_COL;
  V_COL T_ARRAY_COL := T_ARRAY_COL(
  	  T_COL('AUX_APR_BCR_STOCK',',FLAG_EN_REM NUMBER (1)',',FLAG_FICHEROS VARCHAR2(1 CHAR)',',FLAG_OFERTA_VIVA NUMBER (1)'),
      T_COL('AUX_APR_RBC_STOCK','','',''),
      T_COL('AUX_APR_BCR_DELTA',',FLAG_EN_REM NUMBER (1)','',''),
      T_COL('AUX_APR_RBC_DELTA','','','')
	  
   );  
  V_TMP_COL T_COL;





BEGIN

    FOR I IN V_COL.FIRST .. V_COL.LAST
    LOOP
        V_TMP_COL := V_COL(I);
    
  --  DBMS_OUTPUT.PUT_LINE('********'||V_TMP_COL(1)||'********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.'||V_TMP_COL(1)||'... Comprobaciones previas');
    

    -- Verificar si la tabla ya existe
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TMP_COL(1)||''' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
    IF V_NUM_TABLAS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.'||V_TMP_COL(1)||'... Ya existe. Se borrará.');
        EXECUTE IMMEDIATE 'DROP TABLE '||V_ESQUEMA||'.'||V_TMP_COL(1)||' CASCADE CONSTRAINTS';
        
    END IF;

    
    -- Creamos la tabla
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA|| '.'||V_TMP_COL(1)||'...');
    V_MSQL := 'CREATE TABLE ' ||V_ESQUEMA||'.'||V_TMP_COL(1)||'
    (
        NUM_IDENTIFICATIVO          VARCHAR2(8 CHAR),
        NUM_UNIDAD                  VARCHAR2(8 CHAR),
        CLASE_USO                   VARCHAR2(4 CHAR),
        NUM_INMUEBLE                VARCHAR2(16 CHAR),
        CUOTA                       VARCHAR2(10 CHAR),
        GRADO_PROPIEDAD             VARCHAR2(2 CHAR),
        FEC_VALIDO_DE               VARCHAR2(8 CHAR),
        FEC_VALIDO_A                VARCHAR2(8 CHAR),
        STATUS_USUARIO              VARCHAR2(4 CHAR),
        SITUACION_ALQUILER          VARCHAR2(1 CHAR),
        SOCIEDAD_PATRIMONIAL        VARCHAR2(4 CHAR),
        SUBTIPO_VIVIENDA            VARCHAR2(6 CHAR),
        SUBTIPO_SUELO               VARCHAR2(3 CHAR),
        NUM_INMUEBLE_ANTERIOR       VARCHAR2(20 CHAR),

        PRODUCTO                    VARCHAR2(2 CHAR),
        PROCEDENCIA_PRODUCTO        VARCHAR2(2 CHAR),
        SOCIEDAD_ORIGEN             VARCHAR2(4 CHAR),
        BANCO_ORIGEN                VARCHAR2(4 CHAR),

        FINCA                       VARCHAR2(10 CHAR),
        LIBRO                       VARCHAR2(4 CHAR),
        TOMO                        VARCHAR2(4 CHAR),
        FOLIO                       VARCHAR2(4 CHAR),
        INSCRIPCION                 VARCHAR2(4 CHAR),
        NUM_CARTILLA                VARCHAR2(40 CHAR),
        ORIGEN_REGULATORIO          VARCHAR2(2 CHAR),
        CLASE_USO_REGISTRAL         VARCHAR2(4 CHAR),
        IDUFIR                      VARCHAR2(20 CHAR),

        VIVIENDA_HABITUAL           VARCHAR2(1 CHAR),
        FEC_PRESENTACION_REGISTRO   VARCHAR2(8 CHAR),
        FEC_INSC_TITULO             VARCHAR2(8 CHAR),
        FEC_ADJUDICACION            VARCHAR2(8 CHAR),
        FEC_TITULO_FIRME            VARCHAR2(8 CHAR),          
        IMPORTE_CESION              VARCHAR2(10 CHAR),
        FEC_CESION_REMATE           VARCHAR2(8 CHAR),
        FEC_PRESENTADO              VARCHAR2(8 CHAR),
        INDICADOR_LLAVES            VARCHAR2(1 CHAR),
        FEC_RECEP_LLAVES            VARCHAR2(8 CHAR),
        NUM_AUTOS_JUZGADO           VARCHAR2(10 CHAR),
        TIPO_IMPUESTO_COMPRA        VARCHAR2(2 CHAR),
        SUBTIPO_IMPUESTO_COMPRA     VARCHAR2(4 CHAR),
        PORC_IMPUESTO_COMPRA        VARCHAR2(11 CHAR),
        COD_TP_IVA_COMPRA           VARCHAR2(2 CHAR),
        NUM_CARGAS                  VARCHAR2(1 CHAR),
        COD_GESTORIA                VARCHAR2(9 CHAR),
        NOMBRE_REGISTRO_PROPIEDAD   VARCHAR2(40 CHAR),
        NUMERO_REGISTRO_PROPIEDAD   VARCHAR2(40 CHAR),
        COD_GESTORIA_ADMINIS        VARCHAR2(9 CHAR),
        TIPO_ALQUILER               VARCHAR2(2 CHAR),

        COMPLEMENTO                 VARCHAR2(10 CHAR),
        CALLE                       VARCHAR2(60 CHAR),
        NUMERO                      VARCHAR2(10 CHAR),
        APARTADO                    VARCHAR2(5 CHAR),
        POBLACION                   VARCHAR2(5 CHAR),
        REGION                      VARCHAR2(2 CHAR),
        PAIS                        VARCHAR2(2 CHAR),
        CALLE2                      VARCHAR2(40 CHAR),
        DISTRITO                    VARCHAR2(40 CHAR),
        ALA_EDIFICIO                VARCHAR2(2 CHAR),
        PLANTA                      VARCHAR2(3 CHAR),
        NUM_UBICACION               VARCHAR2(5 CHAR),
        X_GOOGLE                    VARCHAR2(23 CHAR),
        Y_GOOGLE                    VARCHAR2(23 CHAR),
        SIGLA_EDIFICIO              VARCHAR2(20 CHAR),

        ESTADO_TITULARIDAD          VARCHAR2(3 CHAR),
        FEC_ESTADO_TITULARIDAD      VARCHAR2(8 CHAR),
        ESTADO_POSESORIO            VARCHAR2(3 CHAR),
        FEC_ESTADO_POSESORIO        VARCHAR2(8 CHAR),
        ESTADO_COMERCIAL_ALQUILER   VARCHAR2(3 CHAR),
        FEC_ESTADO_COMERCIAL_ALQUILER  VARCHAR2(8 CHAR),
        ESTADO_COMERCIAL_VENTA      VARCHAR2(3 CHAR),
        FEC_ESTADO_COMERCIAL_VENTA  VARCHAR2(8 CHAR),
        ESTADO_TECNICO              VARCHAR2(3 CHAR),
        FEC_ESTADO_TECNICO          VARCHAR2(8 CHAR),
        EST_COMERCIAL_SERVICER      VARCHAR2(3 CHAR),
        FEC_COMERCIAL_SERVICER      VARCHAR2(8 CHAR),
        EST_DESA_PROMO_DETALLADO    VARCHAR2(3 CHAR),
        FEC_DESA_PROMO_DETALLADO    VARCHAR2(8 CHAR),
        EST_DESA_PROMO_GENERAL      VARCHAR2(3 CHAR),
        FEC_DESA_PROMO_GENERAL      VARCHAR2(8 CHAR),
        EST_ENTR_PROD_MANT_VENTA    VARCHAR2(3 CHAR),
        FEC_ENTR_PROD_MANT_VENTA    VARCHAR2(8 CHAR),
        EST_ENTR_PROD_MANT_ALQ      VARCHAR2(3 CHAR),
        FEC_ENTR_PROD_MANT_ALQ      VARCHAR2(8 CHAR),


        PROMO_CONJUNTA_OB_REM       VARCHAR2(8 CHAR),
        PROMO_CONJUNTA_VENTA        VARCHAR2(8 CHAR),
        PROMO_CONJUNTA_ALQUILER     VARCHAR2(8 CHAR),
        ACTIVO_CARTERA_CONCENTRADA  VARCHAR2(1 CHAR),
        ACTIVO_AAMM                 VARCHAR2(1 CHAR),
        ACTIVO_PROMO_ESTRATEG       VARCHAR2(1 CHAR),
        DESTINO_COMERCIAL           VARCHAR2(2 CHAR),
        CANAL_DISTRIBUCION_VENTA    VARCHAR2(2 CHAR),
        MOTIVO_NO_COMERCIAL         VARCHAR2(2 CHAR),
        FEC_INICIO_CONCURENCIA      VARCHAR2(8 CHAR),
        FEC_FIN_CONCURENCIA         VARCHAR2(8 CHAR),
        FEC_VISITA_INMB_SERVICER    VARCHAR2(8 CHAR),
        FEC_PUBLICACION_SERVICER    VARCHAR2(8 CHAR),
        PUBLICABLE_PORT_PUBLI_VENTA VARCHAR2(1 CHAR),
        PUBLICABLE_PORT_PUBLI_ALQUI VARCHAR2(1 CHAR),
        PUBLICABLE_PORT_INVER_VENTA VARCHAR2(1 CHAR),
        PUBLICABLE_PORT_INVER_ALQUI VARCHAR2(1 CHAR),
        PUBLICABLE_PORT_API_VENTA   VARCHAR2(1 CHAR),
        PUBLICABLE_PORT_API_ALQUI   VARCHAR2(1 CHAR),
        NECESIDAD_ARRAS             VARCHAR2(2 CHAR),
        MOT_NECESIDAD_ARRAS         VARCHAR2(40 CHAR),
        RENUNCIA_EXENSION           VARCHAR2(1 CHAR),
        CARTERA_VENTA_ACTIVOS       VARCHAR2(4 CHAR),
        CARTERA_VENTA_CREDITOS      VARCHAR2(4 CHAR),       
        CAT_COMERCIALIZACION        VARCHAR2(2 CHAR),
        TRIBUT_PROPUESTA_VENTA      VARCHAR2(2 CHAR),
        TRIBUT_PROPUESTA_CLI_EXT_IVA  VARCHAR2(2 CHAR),
        CANAL_DISTRIBUCION_ALQ VARCHAR2(2 CHAR),
        PROMO_COMERCIAL             VARCHAR2(8 CHAR),
        TXT_COMERCIAL_CAS_1         VARCHAR2(3000 CHAR),
        TXT_COMERCIAL_CAS_2         VARCHAR2(3000 CHAR),
        TXT_COMERCIAL_ENG_1         VARCHAR2(3000 CHAR),
        TXT_COMERCIAL_ENG_2         VARCHAR2(3000 CHAR),
        FEC_PUBLI_SERVICER_APIS     VARCHAR2(8 CHAR),
        FEC_PUBLI_PORT_INVERSOR     VARCHAR2(8 CHAR),
        FEC_INICIO_INFORME          VARCHAR2(8 CHAR),
        FEC_FIN_INFORME             VARCHAR2(8 CHAR),

        ANYO_CONCESION              VARCHAR2(4 CHAR),
        FEC_FIN_CONCESION           VARCHAR2(8 CHAR),
        CALIFICACION_ENERGETICA     VARCHAR2(2 CHAR),
        CERTIFICADO_REGISTRADO      VARCHAR2(1 CHAR),
        FEC_SOLICITUD               VARCHAR2(8 CHAR),
        FEC_FIN_VIGENCIA            VARCHAR2(8 CHAR),
        LISTA_EMISIONES             VARCHAR2(2 CHAR),
        VALORES_EMISIONES           VARCHAR2(10 CHAR),
        LISTA_ENERGIA               VARCHAR2(2 CHAR),
        VALOR_ENERGIA               VARCHAR2(10 CHAR),
        CEDULA_HABITABILIDAD        VARCHAR2(2 CHAR),
        PRECIO_MAX_MOD_VENTA        VARCHAR2(10 CHAR),
        PRECIO_MAX_MOD_ALQUILER     VARCHAR2(10 CHAR),
        SITUACION_VPO               VARCHAR2(4 CHAR),
        NECESARIA_AUTORI_TRANS      VARCHAR2(1 CHAR),
        TANTEO_RETRACTO_TRANS       VARCHAR2(1 CHAR),
        IND_COMPRADOR_ACOGE_AYUDA   VARCHAR2(1 CHAR),
        IMP_AYUDA_FINANCIACION      VARCHAR2(10 CHAR),
        FEC_VENCIMIENTO_SEGURO      VARCHAR2(8 CHAR),
        FEC_DEVOLUCION_AYUDA        VARCHAR2(8 CHAR),
        SITUACION_CEE               VARCHAR2(2 CHAR),
        MOTIVO_EXONERACION_CEE      VARCHAR2(2 CHAR),
        INCIDENCIA_CEE              VARCHAR2(2 CHAR),
        NUMERO_CEE                  VARCHAR2(10 CHAR),
        CODIGO_SST                  VARCHAR2(10 CHAR),

        SUP_TASACION_SOLAR          VARCHAR2(10 CHAR),
        PORC_OBRA_EJECUTADA         VARCHAR2(10 CHAR),
        SUP_TASACION_UTIL           VARCHAR2(10 CHAR),
        SUP_REGISTRAL_UTIL          VARCHAR2(10 CHAR),
        SUP_TASACION_CONSTRUIDA     VARCHAR2(10 CHAR),
        NUM_HABITACIONES            VARCHAR2(10 CHAR),
        NUM_BANYOS                  VARCHAR2(10 CHAR),
        NUM_TERRAZAS                VARCHAR2(10 CHAR),
        ANYO_CONSTRUCCION           VARCHAR2(4 CHAR),
        ANYO_ULTIMA_REFORMA         VARCHAR2(4 CHAR),
        SUP_SOBRE_RASANTE           VARCHAR2(10 CHAR),
        SUP_BAJO_RASANTE            VARCHAR2(10 CHAR),
        NUM_APARACAMIENTOS          VARCHAR2(10 CHAR),
        IDEN_PL_PARKING             VARCHAR2(3 CHAR),
        IDEN_TRASTERO               VARCHAR2(3 CHAR),
        SUP_REG_CONSTRUIDA          VARCHAR2(12 CHAR),
        SUP_REG_SOLAR               VARCHAR2(12 CHAR),

        TIENE_ASCENSOR              VARCHAR2(1 CHAR),
        TIENE_TRASTERO              VARCHAR2(1 CHAR),
        INMUEBLE_VACACIONAL         VARCHAR2(6 CHAR),
        EQUIPAMIENTO_015001         VARCHAR2(6 CHAR),
        BALCON                      VARCHAR2(6 CHAR),
        CALEFACCION                 VARCHAR2(6 CHAR),
        COCINA_EQUIPADA             VARCHAR2(6 CHAR),
        EST_CONSERVACION            VARCHAR2(6 CHAR),
        JARDIN                      VARCHAR2(6 CHAR),
        USO_JARDIN                  VARCHAR2(6 CHAR),
        PISCINA                     VARCHAR2(6 CHAR),
        SALIDA_HUMOS                VARCHAR2(6 CHAR),
        TERRAZA                     VARCHAR2(6 CHAR),
        TIPO_VIVIENDA_INF           VARCHAR2(6 CHAR),
        TIPOLOGIA_EDIFICIO          VARCHAR2(6 CHAR),
        SEG_INVERSION_PROM          VARCHAR2(6 CHAR),

        IMP_PRECIO_VENTA            VARCHAR2(10 CHAR),
        PRECIO_VENTA_NEGOCIABLE     VARCHAR2(1 CHAR),
        DESC_COLEC_PRECIO_ALQUI     VARCHAR2(60 CHAR),
        IMP_PRECIO_ALQUI            VARCHAR2(10 CHAR),
        PRECIO_ALQUI_NEGOCIABLE     VARCHAR2(1 CHAR),
        DESC_COL_PRECIO_CAMP_ALQUI  VARCHAR2(60 CHAR),
        IMP_PRECIO_CAMP_ALQUI       VARCHAR2(10 CHAR),
        PRECIO_CAMP_ALQUI_NEGOCIABLE VARCHAR2(1 CHAR),
        DESC_COL_PRECIO_CAMP_VENTA  VARCHAR2(60 CHAR),
        IMP_PRECIO_CAMP_VENTA       VARCHAR2(10 CHAR),
        PRECIO_CAMP_VENTA_NEGOCIABLE VARCHAR2(1 CHAR),
        DESC_COL_PRECIO_VENTA       VARCHAR2(60 CHAR),
        IMP_PRECIO_REF_ALQUI        VARCHAR2(10 CHAR),     
        FEC_INICIO_PRECIO_VENTA VARCHAR2(8 CHAR),
        FEC_FIN_PRECIO_VENTA    VARCHAR2(8 CHAR),
        FEC_INICIO_PRECIO_ALQUI VARCHAR2(8 CHAR),
        FEC_FIN_PRECIO_ALQUI    VARCHAR2(8 CHAR),
        FEC_INICIO_PRECIO_CAMP_VENTA VARCHAR2(8 CHAR),
        FEC_FIN_PRECIO_CAMP_VENTA VARCHAR2(8 CHAR),
        FEC_INICIO_PRECIO_CAMP_ALQUI VARCHAR2(8 CHAR),
        FEC_FIN_PRECIO_CAMP_ALQUI VARCHAR2(8 CHAR),

        FEC_POSESION                VARCHAR2(8 CHAR),
        FEC_SENYAL_LANZAMIENTO      VARCHAR2(8 CHAR),
        FEC_LANZAMIENTO             VARCHAR2(8 CHAR),
        AVISO_OCUP_SERVICER         VARCHAR2(1 CHAR),
        IND_FUERZA_PUBLICA          VARCHAR2(1 CHAR),
        IND_OCUPANTES_VIVIENDA      VARCHAR2(1 CHAR),
        FEC_RESOLUCION_MORA         VARCHAR2(8 CHAR),
        IND_ENTREGA_VOL_POSESI      VARCHAR2(1 CHAR),

        SEGMENTACION_CARTERA        VARCHAR2(2 CHAR)

        '||V_TMP_COL(2)||'

        '||V_TMP_COL(3)||'

        '||V_TMP_COL(4)||'


        
    )
    LOGGING 
    NOCOMPRESS 
    NOCACHE
    NOPARALLEL
    NOMONITORING
    ';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TMP_COL(1)||'... Tabla creada.');
    

    
    -- Creamos comentario   
    V_MSQL := 'COMMENT ON TABLE '||V_ESQUEMA||'.'||V_TMP_COL(1)||' IS '''||V_COMMENT_TABLE||'''';       
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TMP_COL(1)||'... Comentario creado.');
    
    
    DBMS_OUTPUT.PUT_LINE('[INFO] ' ||V_ESQUEMA||'.'||V_TMP_COL(1)||'... OK');

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUM_IDENTIFICATIVO IS '' Número identificativo del Preinmueble/Número identificativo del Inmueble
/Número identificativo de la superficie inmobiliaria''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUM_UNIDAD IS '' Numero de la Unidad Inmobiliaria''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CLASE_USO IS '' Clase de uso del Preinmueble.
/Clase de uso del Inmuebe.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUM_INMUEBLE IS '' Número de inmueble en el sistema de HAYA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CUOTA IS '' Cuaota de propiedad''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.GRADO_PROPIEDAD IS '' Porcentaje de propiedad''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_VALIDO_DE IS '' Fecha desde de validez del Preinmueble / Inmueble''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_VALIDO_A IS '' Fecha hasta de validez del Preinmueble / Inmueble''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.STATUS_USUARIO IS '' Status usuario LVMS - Declaración de obra nueva''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SITUACION_ALQUILER IS '' Si el activo tiene SI, se envía una X''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SOCIEDAD_PATRIMONIAL IS '' Sociedad propietaria del Inmueble''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUBTIPO_VIVIENDA IS '' Subtipo de activo de vivienda''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUBTIPO_SUELO IS '' Subtipo de activo de suelo''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUM_INMUEBLE_ANTERIOR IS '' Número del inmueble anterior''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PRODUCTO IS '' Procedencia del producto''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PROCEDENCIA_PRODUCTO IS '' Indica si es crediticio o no crediticio''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SOCIEDAD_ORIGEN IS '' Empresa origen''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.BANCO_ORIGEN IS '' Banco origen''';
    
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FINCA IS '' FINCA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.LIBRO IS '' LIBRO''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TOMO IS '' TOMO''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FOLIO IS '' FOLIO''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.INSCRIPCION IS '' INSCRIPCION''';  
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUM_CARTILLA IS '' Número de cartilla evaluatoria que tiene el flag Activa''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ORIGEN_REGULATORIO IS '' Origen regulatorio''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CLASE_USO_REGISTRAL IS '' Clase uso registral''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IDUFIR IS '' Idufir''';
   
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.VIVIENDA_HABITUAL IS '' Marca de si es residencia habitual en la concesión del prestamos''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_PRESENTACION_REGISTRO IS '' Fecha presentación en el registro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_INSC_TITULO IS '' Fecha desde de los estados "Título inscrito" o "Título inscrito con cargas" de la sitaución Proceso judicial titularidad''';
    
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_TITULO_FIRME IS '' Fecha desde de los estados "Decreto firme", "Título" o "Título con defectos" de la sitaución Proceso judicial titularidad''';


    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_PRESENTADO IS '' Fecha real del Estado "Presentado al registro subsanado" de la situación de titularidad''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.INDICADOR_LLAVES IS '' INDICADOR NECESARIO LLAVES''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_RECEP_LLAVES IS '' FECHA RECEPCION DE LLAVES EN 0''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUM_AUTOS_JUZGADO IS '' NUMERO DE AUTOS JUZGADO''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TIPO_IMPUESTO_COMPRA IS '' TIPO IMPUESTO COMPRA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUBTIPO_IMPUESTO_COMPRA IS '' SUBTIPO IMPUESTO COMPRA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PORC_IMPUESTO_COMPRA IS '' PORCENTAJE IMPUESTO COMPRA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.COD_TP_IVA_COMPRA IS '' Cód. TP IVA Compra''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUM_CARGAS IS '' Se deberá calcular si tiene cargas no canceladas. Si las tiene se envía S, y sino N''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.COD_GESTORIA IS '' Código interlocutor con rol Gestoría''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NOMBRE_REGISTRO_PROPIEDAD IS '' Nombre del registro de la propiedad (municipio)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUMERO_REGISTRO_PROPIEDAD IS '' Número del registro de la propiedad''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.COD_GESTORIA_ADMINIS IS '' Código intercolutor con rol Gestoría administrativa''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TIPO_ALQUILER IS '' Tipo alquiler''';
   
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.COMPLEMENTO IS '' Tipo de vía de la dirección''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CALLE IS '' Dirección del OI. Se quiere poner el nombre "Vía"''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUMERO IS '' Número dentro de la calle''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.APARTADO IS '' Código postal''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.POBLACION IS '' Población en formato de 5 dígitos de INE''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.REGION IS '' Provincia con los dos primeros dígitos del Código postal''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PAIS IS '' País''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CALLE2 IS '' Complemento de la calle, en el caso de que por ejemplo un inmueble esté haciendo esquina''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.DISTRITO IS '' Distrito. Usado en cuidades grandes como Madrid o Barcelona''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ALA_EDIFICIO IS '' Escalera''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PLANTA IS '' Planta dentro del Edificio''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUM_UBICACION IS '' Número de la puerta dentro del Edificio''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.X_GOOGLE IS '' Coordenadas X en Google''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.Y_GOOGLE IS '' Coordenadas X en Google''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SIGLA_EDIFICIO IS '' Bloque''';
    
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ESTADO_TITULARIDAD IS '' Estado de la titularidad del activo inmobiliario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_ESTADO_TITULARIDAD IS '' Fecha del estado de la titularidad del activo inmobiliario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ESTADO_POSESORIO IS '' Estado posesorio del activo inmobiliario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_ESTADO_POSESORIO IS '' Fecha del estado posesorio del activo inmobiliario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ESTADO_COMERCIAL_ALQUILER IS '' Estado comercial de alquiler del activo inmobiliario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_ESTADO_COMERCIAL_ALQUILER IS '' Fecha del estado comercial de alquiler del activo inmobiliario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ESTADO_COMERCIAL_VENTA IS '' Estado comercial de venta del activo inmobiliario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_ESTADO_COMERCIAL_VENTA IS '' Fecha del estado comercial de la venta del activo inmobiliario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ESTADO_TECNICO IS '' Estado técnico del activo inmobiliario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_ESTADO_TECNICO IS '' Fecha del estado técnico del activo inmobiliario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.EST_COMERCIAL_SERVICER IS '' Estado comercial Servicer''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_COMERCIAL_SERVICER IS '' Fecha estado comercial Servicer''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.EST_DESA_PROMO_DETALLADO IS '' Estado Desarrollo Promoción detallado''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_DESA_PROMO_DETALLADO IS '' Fecha Desarrollo Promoción detallado''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.EST_DESA_PROMO_GENERAL IS '' Estado Desarrollo Promoción general''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_DESA_PROMO_GENERAL IS '' Fecha Desarrollo Promoción general''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.EST_ENTR_PROD_MANT_VENTA IS '' Estado Entrada producto y mantenimiento venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_ENTR_PROD_MANT_VENTA IS '' Fecha Entrada producto y mantenimiento venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.EST_ENTR_PROD_MANT_ALQ IS '' Estado Entrada producto y mantenimiento alquiler''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_ENTR_PROD_MANT_ALQ IS '' Fecha Entrada producto y mantenimiento alquiler''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PROMO_CONJUNTA_OB_REM IS '' Código de promoción conjunta Ob-rem a la que pertenece el activo inmobiliario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PROMO_CONJUNTA_VENTA IS '' Código de promoción conjunta venta a la que pertenece el activo inmobiliario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PROMO_CONJUNTA_ALQUILER IS '' Código de promoción conjunta alquiler a la que pertenece el activo inmobiliario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ACTIVO_CARTERA_CONCENTRADA IS '' Flag Activo cartera concentrada.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ACTIVO_AAMM IS '' Flag Activo AAMM (Asset Management). Neceista una gestión/explitación''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ACTIVO_PROMO_ESTRATEG IS '' Flag Activo promociones estratégicas''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.DESTINO_COMERCIAL IS '' Destino comercial del activo inmobiliario''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CANAL_DISTRIBUCION_VENTA IS '' Canal distribución venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.MOTIVO_NO_COMERCIAL IS '' Motivo no comercializable''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_INICIO_CONCURENCIA IS '' Fecha inicio concurrencia''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_FIN_CONCURENCIA IS '' Fecha fin concurrencia''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_VISITA_INMB_SERVICER IS '' Fecha visita del inmueble por parte del Servicer''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_PUBLICACION_SERVICER IS '' Fecha de publicación en el Servicer''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PUBLICABLE_PORT_PUBLI_VENTA IS '' Flag Publicable portal público venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PUBLICABLE_PORT_PUBLI_ALQUI IS '' Flag Publicable portal público alquiler''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PUBLICABLE_PORT_INVER_VENTA IS '' Flag Publicable portal inversor venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PUBLICABLE_PORT_INVER_ALQUI IS '' Flag Publicable portal inversor alquiler''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PUBLICABLE_PORT_API_VENTA IS '' Flag Publicable portal API venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PUBLICABLE_PORT_API_ALQUI IS '' Flag Publicable portal API alquiler''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NECESIDAD_ARRAS IS '' Campo que indica si se cumplen o no las condiciones para necesidad de arras. Si es liquidable es que no necesita arras.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.MOT_NECESIDAD_ARRAS IS '' Motivo a informar en el caso de que el campo Liquidez inmueble tenga el valor "Inmueble no líquido"''';
    
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CARTERA_VENTA_ACTIVOS IS '' Cartera venta activos''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CARTERA_VENTA_CREDITOS IS '' Cartera venta créditos''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CAT_COMERCIALIZACION IS '' Tipo de comercialización''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TRIBUT_PROPUESTA_VENTA IS '' Tributación a la que se propone vender el inmueble''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TRIBUT_PROPUESTA_CLI_EXT_IVA IS '' Tirbutación a la que se propone vender en caso de cliente exstenos de IVA''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CANAL_DISTRIBUCION_ALQ IS '' Canal distribución alquiler''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PROMO_COMERCIAL IS '' Promoción comercial''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TXT_COMERCIAL_CAS_1 IS '' Texto comercial castellano''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TXT_COMERCIAL_CAS_2 IS '' Texto comercial castellano''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TXT_COMERCIAL_ENG_1 IS '' Texto comercial inglés''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TXT_COMERCIAL_ENG_2 IS '' Texto comercial inglés''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.RENUNCIA_EXENSION IS '' Renuncia exención''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_PUBLI_SERVICER_APIS IS '' Fecha publicación Servicer portal APIS''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_PUBLI_PORT_INVERSOR IS '' Fecha publicación portal inversor''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_INICIO_INFORME IS '' Fecha de inicio del informe''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_FIN_INFORME IS '' Fecha fin del informe''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ANYO_CONCESION IS '' Año de concesión''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_FIN_CONCESION IS '' Fecha fin de conceción''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CALIFICACION_ENERGETICA IS '' Calificación energética''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CERTIFICADO_REGISTRADO IS '' Es un S/N para saber si se ha registrado el certificado donde toque en la comunidad''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_SOLICITUD IS '' Fecha solicitud certificado energético''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_FIN_VIGENCIA IS '' Fecha fin vigencia certificado energético''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.LISTA_EMISIONES IS '' Lista emisiones''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.VALORES_EMISIONES IS '' Valores emisiones''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.LISTA_ENERGIA IS '' Lista energía''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.VALOR_ENERGIA IS '' Valor energía''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CEDULA_HABITABILIDAD IS '' Cédula habitabilidad''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PRECIO_MAX_MOD_VENTA IS '' Precio máximo módulo venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PRECIO_MAX_MOD_ALQUILER IS '' Precio máximo módulo alquiler''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SITUACION_VPO IS '' Situación V.P.O''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NECESARIA_AUTORI_TRANS IS '' Necesaria autorización transmisión''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TANTEO_RETRACTO_TRANS IS '' Tanteo-Retracto en Transmisión''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IND_COMPRADOR_ACOGE_AYUDA IS '' Indicador de que el comprador se acoge a la ayuda''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IMP_AYUDA_FINANCIACION IS '' Importe ayuda financiación''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_VENCIMIENTO_SEGURO IS '' Fecha vencimiento del aval/seguro''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_DEVOLUCION_AYUDA IS '' Fecha devolución de la ayuda''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SITUACION_CEE IS '' Situación CEE''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.MOTIVO_EXONERACION_CEE IS '' Motivo exoneración CEE''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.INCIDENCIA_CEE IS '' Incidencia CEE''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUMERO_CEE IS '' Número CEE''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CODIGO_SST IS '' Código de la SST''';
    
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUP_TASACION_SOLAR IS '' Superficie tasación solar''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PORC_OBRA_EJECUTADA IS '' Porcentaje obra ejecutada''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUP_TASACION_UTIL IS '' Superficie tasación útil''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUP_REGISTRAL_UTIL IS '' Superficie registral útil''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUP_TASACION_CONSTRUIDA IS '' Superficie tasación construida''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUM_HABITACIONES IS '' Número de habitaciones. Daremos de baja la de la tasación y pondremos la de HAYA. Indicaremos la procedencia.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUM_BANYOS IS '' Número de baños. Daremos de baja la de la tasación y pondremos la de HAYA. Indicaremos la procedencia.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUM_TERRAZAS IS '' Número de terrazas. Daremos de baja la de la tasación y pondremos la de HAYA. Indicaremos la procedencia.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ANYO_CONSTRUCCION IS '' Año de construcción''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ANYO_ULTIMA_REFORMA IS '' Año de última reforma. Daremos de baja la de la tasación y pondremos la de HAYA. Indicaremos la procedencia.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUP_SOBRE_RASANTE IS '' Superficie sobre rasante''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUP_BAJO_RASANTE IS '' Superficie bajo rasante''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUM_APARACAMIENTOS IS '' Número de aparcamientos. Daremos de baja la de la tasación y pondremos la de HAYA. Indicaremos la procedencia.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IDEN_PL_PARKING IS '' Identificador plaza parking.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IDEN_TRASTERO IS '' Identificador trastero.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUP_REG_CONSTRUIDA IS '' Superficie Registral Construida.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUP_REG_SOLAR IS '' Superficie Registral Solar.''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TIENE_ASCENSOR IS '' Marca de si tiene ascensor. PDaremos de baja la de la tasación y pondremos la de HAYA. Indicaremos la procedencia.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TIENE_TRASTERO IS '' Marca de si tiene trastero. Daremos de baja la de la tasación y pondremos la de HAYA. Indicaremos la procedencia.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.INMUEBLE_VACACIONAL IS '' Marca de si es un inmueble vacacional.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.EQUIPAMIENTO_015001 IS '' Marca de si tiene parking''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.BALCON IS '' Balcón''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CALEFACCION IS '' Calefacción.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.COCINA_EQUIPADA IS '' Cocina Equipada.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.EST_CONSERVACION IS '' Estado conservación.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.JARDIN IS '' Jardín.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.USO_JARDIN IS '' Uso Jardín.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PISCINA IS '' Piscina.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SALIDA_HUMOS IS '' Salida De Humos.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TERRAZA IS '' Terraza.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TIPO_VIVIENDA_INF IS '' Tipo vivienda.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TIPOLOGIA_EDIFICIO IS '' Tipología Edificio.''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SEG_INVERSION_PROM IS '' Segmento inversión promoción.''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IMP_PRECIO_VENTA IS '' Importe Clase de condición Precio de venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PRECIO_VENTA_NEGOCIABLE IS '' Flag precio venta negociable''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.DESC_COLEC_PRECIO_ALQUI IS '' Conjunto de descuentos colectivos que se pueden aplicar''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IMP_PRECIO_ALQUI IS '' Importe Clase de condición Precio de alquiler''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PRECIO_ALQUI_NEGOCIABLE IS '' Flag precio alquiler negociable''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.DESC_COL_PRECIO_CAMP_ALQUI IS '' Conjunto de descuentos colectivos que se pueden aplicar''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IMP_PRECIO_CAMP_ALQUI IS '' Importe Clase de condición precio campaña alquiler''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PRECIO_CAMP_ALQUI_NEGOCIABLE IS '' Flag precio campaña alquiler negociable''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.DESC_COL_PRECIO_CAMP_VENTA IS '' Conjunto de descuentos colectivos que se pueden aplicar''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IMP_PRECIO_CAMP_VENTA IS '' Importe Clase de condición precio campaña venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PRECIO_CAMP_VENTA_NEGOCIABLE IS '' Flag precio campaña venta negociable''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.DESC_COL_PRECIO_VENTA IS '' Conjunto de descuentos colectivos que se pueden aplicar''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IMP_PRECIO_REF_ALQUI IS '' Importe Clase de condición precio referencia alquiler''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_INICIO_PRECIO_VENTA IS '' Fecha inicio precio venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_FIN_PRECIO_VENTA IS '' Fecha fin precio venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_INICIO_PRECIO_ALQUI IS '' Fecha inicio precio alquiler''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_FIN_PRECIO_ALQUI IS '' Fecha fin precio alquiler''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_INICIO_PRECIO_CAMP_VENTA IS '' Fecha inicio precio campaña venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_FIN_PRECIO_CAMP_VENTA IS '' Fecha fin precio campaña venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_INICIO_PRECIO_CAMP_ALQUI IS '' Fecha inicio precio campaña alquiler''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_FIN_PRECIO_CAMP_ALQUI IS '' Fecha fin precio campaña alquiler''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_POSESION IS '' Fecha realizada posesión''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_SENYAL_LANZAMIENTO IS '' Fecha señalado lanzamiento''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_LANZAMIENTO IS '' Fecha realizado lanzamiento''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.AVISO_OCUP_SERVICER IS '' Indicador ocupado''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IND_FUERZA_PUBLICA IS '' Ind. Necesaria Fuerza Pública''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IND_OCUPANTES_VIVIENDA IS '' Ind. Existencia Ocupantes Vivi''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_RESOLUCION_MORA IS '' Fecha Resolución Moratoria''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IND_ENTREGA_VOL_POSESI IS '' Ind. Entrega Voluntaria Posesi (llaves)''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SEGMENTACION_CARTERA IS '' Segmentación cartera''';


 END LOOP;

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
