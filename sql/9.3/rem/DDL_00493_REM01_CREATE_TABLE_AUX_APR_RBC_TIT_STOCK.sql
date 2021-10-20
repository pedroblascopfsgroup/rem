--/*
--##########################################
--## AUTOR=Daniel Algaba
--## FECHA_CREACION=20211018
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-15634
--## PRODUCTO=NO
--## Finalidad: Interfax Stock REM 
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial - HREOS-15217 - Daniel Algaba
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
    V_TEXT_TABLA VARCHAR2(2400 CHAR) := 'AUX_APR_RBC_TIT_STOCK'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.
    V_COMMENT_TABLE VARCHAR2(500 CHAR):= ''; -- Vble. para los comentarios de las tablas

    TYPE T_COL IS TABLE OF VARCHAR2(500 CHAR);
    TYPE T_ARRAY_COL IS TABLE OF T_COL;
    V_COL T_ARRAY_COL := T_ARRAY_COL(
        T_COL('AUX_APR_RBC_TIT_STOCK')
        
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
        SOCIEDAD_PATRIMONIAL        VARCHAR2(4 CHAR),
        FONDO                       VARCHAR2(20 CHAR),
        ESTADO_POSESORIO            VARCHAR2(3 CHAR),
        FEC_ESTADO_POSESORIO        VARCHAR2(8 CHAR),
        FEC_TITULO_FIRME            VARCHAR2(8 CHAR), 
        PORC_OBRA_EJECUTADA         VARCHAR2(7 CHAR),
        FEC_COMPRA                  VARCHAR2(8 CHAR),
        FEC_VALIDO_DE               VARCHAR2(8 CHAR),
        SUBTIPO_VIVIENDA            VARCHAR2(1 CHAR),
        FEC_ULT_REHAB               VARCHAR2(8 CHAR),
        IND_OCUPANTES_VIVIENDA      VARCHAR2(1 CHAR),
        PRODUCTO                    VARCHAR2(2 CHAR),
        VENTA                       VARCHAR2(1 CHAR),
        SITUACION_VPO               VARCHAR2(4 CHAR),
        LIC_PRI_OCUPACION           VARCHAR2(1 CHAR),
        CLASE_USO                   VARCHAR2(4 CHAR),
        SUBTIPO_SUELO               VARCHAR2(3 CHAR),

        ACUERDO_PAGO                VARCHAR2(1 CHAR),
        ALQUILADO                   VARCHAR2(1 CHAR),
        MOROSO                      VARCHAR2(1 CHAR),
        ACTIVO_PROMO_ESTRATEG       VARCHAR2(1 CHAR),
        ALQUILER_GESTION            VARCHAR2(1 CHAR),

        FEC_VENTA                   VARCHAR2(8 CHAR),
        IMP_VENTA                   VARCHAR2(15 CHAR),
        NIF_COMPRADOR               VARCHAR2(16 CHAR),
        INGRESOS_COMPRADOR          VARCHAR2(15 CHAR),

        TASADORA                    VARCHAR2(10 CHAR),
        FEC_TASACION                VARCHAR2(8 CHAR),
        GASTO_COM_TASACION          VARCHAR2(15 CHAR),
        IMP_TAS_INTEGRO             VARCHAR2(15 CHAR),
        REF_ID_TASADORA             VARCHAR2(20 CHAR),
        TIPO_VAL_EST_TASACION       VARCHAR2(1 CHAR),
        FLAG_PORC_COSTE_DEFECTO     VARCHAR2(1 CHAR),
        APROV_PARCELA               VARCHAR2(10 CHAR),
        DESAROLLO_PLANT             VARCHAR2(3 CHAR),
        FASE_GESTION                VARCHAR2(3 CHAR),
        ACO_NORMATIVA               VARCHAR2(2 CHAR),
        NUM_VIVIENDAS               VARCHAR2(3 CHAR),
        PORC_AMB_VALORADO           VARCHAR2(7 CHAR),
        PRODUCTO_DESAR              VARCHAR2(3 CHAR),
        PROX_NUCLEO_URB             VARCHAR2(3 CHAR),
        SISTEMA_GESTION             VARCHAR2(3 CHAR),
        SUPERFICIE_ADOPTADA         VARCHAR2(6 CHAR),
        SUPERFICIE_PARCELA          VARCHAR2(6 CHAR),
        SUPERFICIE                  VARCHAR2(6 CHAR),
        TIPO_SUELO_TAS              VARCHAR2(3 CHAR),
        VAL_HIP_EDI_TERM_PROM       VARCHAR2(12 CHAR),
        ADVERTENCIAS                VARCHAR2(2 CHAR),
        APROVECHAMIENTO             VARCHAR2(15 CHAR),
        COD_SOCIEDAD_TAS            VARCHAR2(10 CHAR),
        CONDICIONANTES              VARCHAR2(2 CHAR),
        COST_EST_TER_OBRA           VARCHAR2(15 CHAR),
        COST_DEST_USO_PROPIO        VARCHAR2(15 CHAR),
        FEC_ULT_GRA_AVANCA_EST      VARCHAR2(8 CHAR),
        FEC_EST_TER_OBRA            VARCHAR2(8 CHAR),
        FINCA_RUS_EXP_URB           VARCHAR2(1 CHAR),
        MET_VALORACION              VARCHAR2(2 CHAR),
        PLA_MAX_IN_COM              VARCHAR2(3 CHAR),
        PLA_MAX_IN_CON              VARCHAR2(3 CHAR),
        TASA_ANU_HOMOGENEA          VARCHAR2(5 CHAR),
        TIPO_ACTUALIZACION          VARCHAR2(5 CHAR),
        MARGEN_BEN_PROMOTOR         VARCHAR2(5 CHAR),
        PARALIZACION_URB            VARCHAR2(1 CHAR),
        PORC_URB_EJECUTADO          VARCHAR2(5 CHAR),
        PORC_AMBITO_VAL             VARCHAR2(5 CHAR),
        PRODUCTO_DESA               VARCHAR2(2 CHAR),
        PROYECTO_OBRA               VARCHAR2(1 CHAR),
        SUPERFICIE_TERRENO          VARCHAR2(15 CHAR),
        TASA_ANU_MED_VAR_PRECIO     VARCHAR2(5 CHAR),
        TIPO_DAT_INM_COMPARABLES    VARCHAR2(2 CHAR),
        VAL_TERRENO                 VARCHAR2(15 CHAR),
        VAL_TERRENO_AJUSTADO        VARCHAR2(15 CHAR),
        VAL_HIP_EDI_TERMINADO       VARCHAR2(15 CHAR),
        VAL_HIPOTECARIO             VARCHAR2(15 CHAR),
        VISITA_INT_INMUEBLE         VARCHAR2(1 CHAR)        
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

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUM_IDENTIFICATIVO IS ''Código inmueble''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SOCIEDAD_PATRIMONIAL IS ''Sociedad Gestora''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FONDO IS ''Fondo''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ESTADO_POSESORIO IS ''Estado Situacion posesoria''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_ESTADO_POSESORIO IS ''Fecha inicio estado posesorio''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_TITULO_FIRME IS ''Fecha titulo''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PORC_OBRA_EJECUTADA IS ''% construccion ''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_COMPRA IS ''Fecha compra''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_VALIDO_DE IS ''Fecha de alta en sistema''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUBTIPO_VIVIENDA IS ''Tipo de vivienda''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_ULT_REHAB IS ''Fecha de la última rehabilitación''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IND_OCUPANTES_VIVIENDA IS ''Ind. Existencia Ocupantes Vivienda''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PRODUCTO IS ''Forma Obtención de la posesión''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.VENTA IS ''Inmueble disponible para la venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SITUACION_VPO IS ''Situación VPO''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.LIC_PRI_OCUPACION IS ''Licencia de primera ocupación''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CLASE_USO IS ''Clase de uso''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUBTIPO_SUELO IS ''Clasificación suelo según CBE''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ACUERDO_PAGO IS ''Acuerdo de pago (SI/NO)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ALQUILADO IS ''Alquilado/No alquilado''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.MOROSO IS ''Moroso/No Moroso (SI/NO)''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ACTIVO_PROMO_ESTRATEG IS ''Activo Estratégico''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ALQUILER_GESTION IS ''Alquiler de gestión''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_VENTA IS ''Fecha venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IMP_VENTA IS ''Importe venta''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NIF_COMPRADOR IS ''NIF''';
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.INGRESOS_COMPRADOR IS ''Ingresos''';

    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TASADORA IS ''Empresa tasadora''';                 
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_TASACION IS ''Fecha Tasación''';             
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.GASTO_COM_TASACION IS ''Gasto Comercialización tasación''';       
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.IMP_TAS_INTEGRO IS ''Importe Tasación Integro''';          
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.REF_ID_TASADORA IS ''Referencia ID tasadora''';          
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TIPO_VAL_EST_TASACION IS ''Tipo de Valoración Estado Tasación''';    
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FLAG_PORC_COSTE_DEFECTO IS ''Flag % coste por defecto''';  
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.APROV_PARCELA IS ''Aprovechamiento de la parcela en m2 (suelo)''';            
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.DESAROLLO_PLANT IS ''Desarrollo del planeamiento''';          
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FASE_GESTION IS ''Fase de gestión''';             
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ACO_NORMATIVA IS ''Acogida normativa''';            
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.NUM_VIVIENDAS IS ''Número de viviendas''';            
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PORC_AMB_VALORADO IS ''Porcentaje de ámbito valorado''';        
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PRODUCTO_DESAR IS ''Producto a desarrollar''';           
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PROX_NUCLEO_URB IS ''Proximidad respecto a núcleo urbano''';          
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SISTEMA_GESTION IS ''Sistema de gestión''';          
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUPERFICIE_ADOPTADA IS ''Superficie adoptada (metros cuadrados)''';      
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUPERFICIE_PARCELA IS ''Superficie de la parcela en m2 (suelo)''';       
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUPERFICIE IS ''Superficie en m2''';               
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TIPO_SUELO_TAS IS ''Tipo de suelo''';           
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.VAL_HIP_EDI_TERM_PROM IS ''Valor en hipótesis de edificio terminado (promociones)''';    
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.ADVERTENCIAS IS ''Advertencias''';             
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.APROVECHAMIENTO IS ''Aprovechamiento (m2)''';          
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.COD_SOCIEDAD_TAS IS ''Código de la sociedad de tasación/valoración''';         
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.CONDICIONANTES IS ''Condicionantes''';           
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.COST_EST_TER_OBRA IS ''Coste estimado para terminar la obra''';        
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.COST_DEST_USO_PROPIO IS ''Coste por el que se destina a uso propio''';     
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_ULT_GRA_AVANCA_EST IS ''Fecha del último grado de avance estimado''';   
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FEC_EST_TER_OBRA IS ''Fecha estimada para terminar la obra''';         
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.FINCA_RUS_EXP_URB IS ''Finca rústica con expectativas urbanísticas''';        
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.MET_VALORACION IS ''Método de valoración''';           
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PLA_MAX_IN_COM IS ''Método residual dinámico. Plazo máximo para finalizar a la comercialización (meses)''';           
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PLA_MAX_IN_CON IS ''Método residual dinámico. Plazo máximo para finalizar la construcción (meses)''';           
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TASA_ANU_HOMOGENEA IS ''Método residual dinámico. Tasa anualizada homogénea [%]''';       
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TIPO_ACTUALIZACION IS ''Método residual dinámico. Tipo de Actualización [%]''';       
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.MARGEN_BEN_PROMOTOR IS ''Método residual estático. Margen de beneficio del promotor [%]''';      
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PARALIZACION_URB IS ''Paralización de la urbanización''';         
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PORC_URB_EJECUTADO IS ''Porcentaje de la urbanización ejecutado (%)''';       
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PORC_AMBITO_VAL IS ''Porcentaje del ámbito valorado (%)''';          
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PRODUCTO_DESA IS ''Producto que se prevé desarrollar''';            
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.PROYECTO_OBRA IS ''Proyecto de obra''';            
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.SUPERFICIE_TERRENO IS ''Superficie del terreno (m2)''';       
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TASA_ANU_MED_VAR_PRECIO IS ''Tasa anual media de variación del precio de mercado del activo [%]''';  
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.TIPO_DAT_INM_COMPARABLES IS ''Tipo de datos utilizados de inmuebles comparables'''; 
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.VAL_TERRENO IS ''Valor del terreno''';              
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.VAL_TERRENO_AJUSTADO IS ''Valor del terreno ajustado''';     
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.VAL_HIP_EDI_TERMINADO IS ''Valor en hipótesis de edificio terminado''';    
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.VAL_HIPOTECARIO IS ''Valor hipotecario''';          
    EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_TMP_COL(1)||'.VISITA_INT_INMUEBLE IS ''Visita al interior del inmueble'''; 

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
