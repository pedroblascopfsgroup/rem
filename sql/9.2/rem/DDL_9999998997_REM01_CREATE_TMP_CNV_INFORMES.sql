--/*
--##########################################
--## AUTOR=NURIA GARCES
--## FECHA_CREACION=20190117
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.5
--## INCIDENCIA_LINK=HREOS-5223
--## PRODUCTO=No
--## Finalidad: DDL Creacion tablas temporales ETL
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
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar

    BEGIN


    DBMS_OUTPUT.PUT_LINE('******** TMP_CNV_BIE ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_CNV_BIE... Comprobaciones previas'); 
  
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_CNV_BIE'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('TMP_CNV_BIE... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla TMP_CNV_BIE
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TMP_CNV_BIE
               (BIE_ID NUMBER(16,0), 
				BIE_ENTIDAD_ID VARCHAR2 (250 CHAR),
				BIE_REFERENCIA_MUEBLE VARCHAR2(50 BYTE), 
				BIE_REFERENCIA_CATASTRAL VARCHAR2(50 CHAR), 
				BIE_ULTIMA_PETICION_NOTA TIMESTAMP (6)	
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TMP_CNV_BIE... Tabla creada');

    END IF;
    
    DBMS_OUTPUT.PUT_LINE('******** TMP_CNV_BCN ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_CNV_BCN... Comprobaciones previas'); 
  
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_CNV_BCN'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('TMP_CNV_BCN... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla TMP_CNV_BCN
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TMP_CNV_BCN
               (BIE_ID NUMBER(16,0), 
				CNT_CONTRATO VARCHAR2(50 CHAR) 
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TMP_CNV_BCN... Tabla creada');

    END IF;
    
    DBMS_OUTPUT.PUT_LINE('******** TMP_CNV_CAR ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_CNV_CAR... Comprobaciones previas'); 
  
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_CNV_CAR'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('TMP_CNV_CAR... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla TMP_CNV_CAR
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TMP_CNV_CAR
               (BIE_ID NUMBER(16,0), 
                BIE_CAR_ID NUMBER(16,0),
                DD_TPC_CODIGO VARCHAR2(10 CHAR),
                BIE_CAR_TITULAR VARCHAR2(50 CHAR),
                BIE_CAR_IMPORTE_REGISTRAL NUMBER(16,2),
                BIE_CAR_IMPORTE_ECONOMICO NUMBER(16,2),
                BIE_CAR_REGISTRAL NUMBER(1,0),
                DD_SIC_CODIGO VARCHAR2(10 CHAR),
                BIE_CAR_FECHA_INSCRIPCION DATE,
                BIE_CAR_LETRA VARCHAR2(50 CHAR),
                BIE_CAR_FECHA_CANCELACION DATE,
                BIE_CAR_FECHA_PRESENTACION DATE            
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TMP_CNV_CAR... Tabla creada');

    END IF;
    
    DBMS_OUTPUT.PUT_LINE('******** TMP_CNV_ADJ ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_CNV_ADJ... Comprobaciones previas'); 
  
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_CNV_ADJ''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('TMP_CNV_ADJ... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla TMP_CNV_ADJ
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TMP_CNV_ADJ
               (BIE_ID NUMBER(16,0), 
                BIE_ADI_FFIN_REV_CARGA DATE,
                BIE_ADJ_F_DECRETO_N_FIRME DATE,
                BIE_ADJ_F_DECRETO_FIRME DATE,
                BIE_ADJ_F_REA_POSESION DATE,
                BIE_ADJ_IMPORTE_ADJUDICACION NUMBER(16,2),
                DD_SIT_CODIGO VARCHAR2(10 CHAR),
                BIE_ADJ_F_ENTREGA_GESTOR DATE,
                BIE_ADJ_F_PRESEN_HACIENDA DATE,
                BIE_ADJ_F_PRESENT_REGISTRO DATE,
                BIE_ADJ_F_ENVIO_ADICION DATE,
                BIE_ADJ_F_SEGUNDA_PRESEN DATE,
                BIE_ADJ_F_INSCRIP_TITULO DATE,
                BIE_ADJ_F_RECPCION_TITULO DATE,
                BIE_ADJ_F_SEN_POSESION DATE,
                BIE_ADJ_POSIBLE_POSESION NUMBER(1,0),
                BIE_ADJ_OCUPADO NUMBER(1,0),
                BIE_ADJ_F_SOL_LANZAMIENTO DATE,
                BIE_ADJ_F_SEN_LANZAMIENTO DATE,
                BIE_ADJ_F_REA_LANZAMIENTO DATE,
                BIE_ADJ_F_CONTRATO_ARREN DATE,
                BIE_ADJ_F_RES_MORATORIA DATE,
                BIE_ADJ_LLAVES_NECESARIAS NUMBER(1,0),
                BIE_ADJ_F_RECEP_DEPOSITARIO DATE,
                ASU_ID_EXTERNO VARCHAR2(50 BYTE),
                DD_JUZ_CODIGO VARCHAR2(20 CHAR),
                DD_PLA_CODIGO VARCHAR2(20 CHAR),
                PRC_COD_PROC_EN_JUZGADO VARCHAR2(50 CHAR),
                USU_USERNAME VARCHAR2(50 CHAR),
                DES_DESPACHO VARCHAR2(100 CHAR),
                DD_TPN_CODIGO VARCHAR2(50 CHAR),
                DD_LOC_CODIGO VARCHAR2(20 CHAR),
                BIE_DREG_CODIGO_REGISTRO VARCHAR2(50 CHAR),
                BIE_DREG_TOMO VARCHAR2(50 CHAR),
                BIE_DREG_LIBRO VARCHAR2(50 CHAR),
                BIE_DREG_FOLIO VARCHAR2(50 CHAR),
                BIE_DREG_NUM_FINCA VARCHAR2(50 BYTE),
                BIE_DREG_CRU VARCHAR2(20 CHAR),
                BIE_DREG_SUPERFICIE_CONSTRUIDA NUMBER(16,2),
                BIE_DREG_SUPERFICIE NUMBER(16,2),
                DD_TVI_CODIGO VARCHAR2(100 CHAR),
                BIE_LOC_NOMBRE_VIA VARCHAR2(100 CHAR),
                BIE_LOC_NUMERO_DOMICILIO VARCHAR2(100 CHAR),
                BIE_LOC_ESCALERA VARCHAR2(10 CHAR),
                BIE_LOC_PISO VARCHAR2(10 CHAR),
                BIE_LOC_PUERTA VARCHAR2(10 CHAR),
                BIE_LOC_PROVINCIA VARCHAR2(2 CHAR),
                BIE_LOC_MUNICIPIO VARCHAR2(100 CHAR),
                DD_UPO_CODIGO VARCHAR2(10 CHAR),
                DD_CIC_CODIGO VARCHAR2(20 CHAR),
                BIE_LOC_COD_POST VARCHAR2(250 CHAR)
               )';
               
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TMP_CNV_ADJ... Tabla creada');

    END IF;
    
    DBMS_OUTPUT.PUT_LINE('******** TMP_CNV_DAC ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_CNV_DAC... Comprobaciones previas'); 
  
    -- Comprobamos si existe la tabla   
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_CNV_DAC'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('TMP_CNV_DAC... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla TMP_CNV_BIE
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TMP_CNV_DAC
               (ACT_RECOVERY_ID NUMBER(16,0), 
				ACT_NUM_ACTIVO NUMBER(16,0)
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TMP_CNV_DAC... Tabla creada');

    END IF;
    
    DBMS_OUTPUT.PUT_LINE('******** TMP_CNV_DRE ********'); 
    DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_CNV_DRE... Comprobaciones previas'); 
  
    -- Comprobamos si existe la tabla  
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_CNV_DRE'' ';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
            DBMS_OUTPUT.PUT_LINE('TMP_CNV_DRE... Tabla YA EXISTE');    
    ELSE  
    	 --Creamos la tabla TMP_CNV_BIE
    	 V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.TMP_CNV_DRE
               (BIE_ID NUMBER(16,0)
              , BIE_ENTIDAD_ID VARCHAR2 (250 CHAR)
              , FECHA_TITULO DATE
              , TRAMITADOR_TITULO VARCHAR2(1000 CHAR)
              , FECHA_FIRMA_TITULO DATE
              , VALOR_ADQUISICION NUMBER(16,2)
              , NUM_REFERENCIA VARCHAR2 (250 CHAR)
              , BIE_ADI_FFIN_REV_CARGA DATE
              , DD_TPN_CODIGO VARCHAR2(50 CHAR)
              , DD_LOC_CODIGO VARCHAR2(20 CHAR)
              , BIE_DREG_CODIGO_REGISTRO VARCHAR2(50 CHAR)
              , BIE_DREG_TOMO VARCHAR2(50 CHAR)
              , BIE_DREG_LIBRO VARCHAR2(50 CHAR)
              , BIE_DREG_FOLIO VARCHAR2(50 CHAR)
              , BIE_DREG_NUM_FINCA VARCHAR2(50 CHAR)
              , BIE_DREG_CRU VARCHAR2(20 CHAR)
              , BIE_DREG_SUPERFICIE_CONSTRUIDA NUMBER(16,2)
              , BIE_DREG_SUPERFICIE NUMBER(16,2)
              , DD_TVI_CODIGO VARCHAR2(100 CHAR)
              , BIE_LOC_NOMBRE_VIA VARCHAR2(100 CHAR)
              , BIE_LOC_NUMERO_DOMICILIO VARCHAR2(100 CHAR)
              , BIE_LOC_ESCALERA VARCHAR2(10 CHAR)
              , BIE_LOC_PISO VARCHAR2(10 CHAR)
              , BIE_LOC_PUERTA VARCHAR2(10 CHAR)
              , BIE_LOC_PROVINCIA VARCHAR2(2 CHAR)
              , BIE_LOC_MUNICIPIO VARCHAR2(100 CHAR)
              , DD_UPO_CODIGO VARCHAR2(10 CHAR)
              , DD_CIC_CODIGO VARCHAR2(20 CHAR)
              , BIE_LOC_COD_POST VARCHAR2(250 CHAR)
               )';
		EXECUTE IMMEDIATE V_MSQL;
		DBMS_OUTPUT.PUT_LINE('[INFO] ' || V_ESQUEMA || '.TMP_CNV_DRE... Tabla creada');

    END IF;
    
    
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
