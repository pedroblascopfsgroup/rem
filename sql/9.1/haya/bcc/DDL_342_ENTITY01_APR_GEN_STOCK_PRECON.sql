--/*
--##########################################
--## AUTOR=MIGUEL ANGEL SANCHEZ
--## FECHA_CREACION=25-11-2015
--## ARTEFACTO=PCO_BUROFAX
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=HR-
--## PRODUCTO=SI
--## Finalidad: DDL creacion tablas AUX_STOCK_PRECON_PRC, AUX_STOCK_PRECON_LIQ, AUX_STOCK_PRECON_DOC, AUX_STOCK_PRECON_SOL Y AUX_STOCK_LITIGIOS_PRCPER
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
    V_TABLA VARCHAR2(100 CHAR); --Vble. para guardar la tabla
    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar     
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.   
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    V_TEXT1 VARCHAR2(2400 CHAR); -- Vble. auxiliar
    V_ENTIDAD_ID NUMBER(16);



BEGIN

-----------------------------------------------------------------------------------------------------------------------------------
V_TABLA :='AUX_STOCK_PRECON_PRC';
DBMS_OUTPUT.PUT_LINE('[INICIO] Crear tabla: '||V_ESQUEMA||'.'||V_TABLA||'...');
V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Creando tabla');
    V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'(
                  PCO_PRC_SYS_GUID VARCHAR2(36 CHAR) NOT NULL 
                , PRC_SYS_GUID VARCHAR2(32 BYTE) NOT NULL 
                , PCO_PRC_TIPO_PRC_PROP VARCHAR2(20 CHAR) 
                , PCO_PRC_TIPO_PRC_INICIADO VARCHAR2(20 CHAR) 
                , PCO_PRC_PRETURNADO NUMBER(38, 0) NOT NULL 
                , PCO_PRC_NUM_EXP_EXT VARCHAR2(50 CHAR) 
                , PCO_PRC_NOM_EXP_JUD VARCHAR2(50 CHAR) 
                , PCO_PRC_CNT_PRINCIPAL NUMBER(16, 0) 
                , PCO_PRC_NUM_EXP_INT VARCHAR2(50 CHAR) 
                , DD_PCO_PTP_ID VARCHAR2(2 CHAR) 
                , VERSION NUMBER(38, 0) DEFAULT 0 NOT NULL 
                , USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL 
                , FECHACREAR TIMESTAMP(6) NOT NULL 
                , USUARIOMODIFICAR VARCHAR2(50 CHAR) 
                , FECHAMODIFICAR TIMESTAMP(6) 
                , USUARIOBORRAR VARCHAR2(50 CHAR) 
                , FECHABORRAR TIMESTAMP(6) 
                , BORRADO NUMBER(1, 0) DEFAULT 0 NOT NULL 
              )';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_ESQUEMA||'.'||V_TABLA||' creada.');      	
ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ya existe');
END IF;

-----------------------------------------------------------------------------------------------------------------------------------
V_TABLA :='AUX_STOCK_PRECON_LIQ';
DBMS_OUTPUT.PUT_LINE('[INICIO] Crear tabla: '||V_ESQUEMA||'.'||V_TABLA||'...');
V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Creando tabla');
    V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'(
                PCO_LIQ_SYS_GUID VARCHAR2(36 CHAR) NOT NULL 
                , PCO_PRC_SYS_GUID VARCHAR2(36 CHAR) NOT NULL 
                , DD_PCO_LIQ_ID VARCHAR2(20 CHAR) NOT NULL 
                , CNT_CONTRATO NUMBER(16, 0) NOT NULL 
                , PCO_LIQ_FECHA_SOLICITUD TIMESTAMP(6) 
                , PCO_LIQ_FECHA_RECEPCION TIMESTAMP(6) 
                , PCO_LIQ_FECHA_CONFIRMACION TIMESTAMP(6) 
                , PCO_LIQ_FECHA_CIERRE TIMESTAMP(6) 
                , PCO_LIQ_CAPITAL_VENCIDO NUMBER(16, 2) 
                , PCO_LIQ_CAPITAL_NO_VENCIDO NUMBER(16, 2) 
                , PCO_LIQ_INTERESES_DEMORA NUMBER(16, 2) 
                , PCO_LIQ_INTERESES_ORDINARIOS NUMBER(16, 2) 
                , PCO_LIQ_TOTAL NUMBER(16, 2) 
                , PCO_LIQ_ORI_CAPITAL_VENCIDO NUMBER(16, 2) 
                , PCO_LIQ_ORI_CAPITAL_NO_VENCIDO NUMBER(16, 2) 
                , PCO_LIQ_ORI_INTE_DEMORA NUMBER(16, 2) 
                , PCO_LIQ_ORI_INTE_ORDINARIOS NUMBER(16, 2) 
                , PCO_LIQ_ORI_TOTAL NUMBER(16, 2) 
                , USD_ID NUMBER(16, 0)
                , VERSION NUMBER(*, 0) DEFAULT 0 NOT NULL 
                , USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL 
                , FECHACREAR TIMESTAMP(6) NOT NULL 
                , USUARIOMODIFICAR VARCHAR2(50 CHAR) 
                , FECHAMODIFICAR TIMESTAMP(6) 
                , USUARIOBORRAR VARCHAR2(50 CHAR) 
                , FECHABORRAR TIMESTAMP(6) 
                , BORRADO NUMBER(1, 0) DEFAULT 0 NOT NULL 
                , PCO_LIQ_COMISIONES NUMBER(16, 2) 
                , PCO_LIQ_GASTOS NUMBER(16, 2) 
                , PCO_LIQ_IMPUESTOS NUMBER(16, 2) 
                , PCO_LIQ_ORI_COMISIONES NUMBER(16, 2) 
                , PCO_LIQ_ORI_GASTOS NUMBER(16, 2) 
                , PCO_LIQ_ORI_IMPUESTOS NUMBER(16, 2) 
                , PCO_LIQ_SOLICITANTE NUMBER(16, 0) 
                , PCO_LIQ_FECHA_VISADO TIMESTAMP(6) 
              )';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_ESQUEMA||'.'||V_TABLA||' creada.');       	
ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ya existe');
END IF;

-----------------------------------------------------------------------------------------------------------------------------------
V_TABLA :='AUX_STOCK_PRECON_DOC';
DBMS_OUTPUT.PUT_LINE('[INICIO] Crear tabla: '||V_ESQUEMA||'.'||V_TABLA||'...');
V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Creando tabla');
    V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'(
              PCO_DOC_PDD_SYS_GUID VARCHAR2(36 CHAR) NOT NULL 
            , PCO_PRC_SYS_GUID VARCHAR2(36 CHAR) NOT NULL 
            , DD_PCO_DED_ID VARCHAR2(2 CHAR) NOT NULL 
            , DD_PCO_DTD_ID VARCHAR2(2 CHAR) NOT NULL 
            , DD_TFA_ID VARCHAR2(20 CHAR) NOT NULL 
            , PCO_DOC_PDD_UG_ID NUMBER(16, 0) NOT NULL 
            , PCO_DOC_PDD_UG_DESC VARCHAR2(50 CHAR) 
            , PCO_DOC_PDD_ADJUNTO NUMBER(*, 0) DEFAULT 0 NOT NULL 
            , PCO_DOC_PDD_PROTOCOLO VARCHAR2(50 CHAR) 
            , PCO_DOC_PDD_NOTARIO VARCHAR2(50 CHAR) 
            , PCO_DOC_PDD_FECHA_ESCRIT TIMESTAMP(6) 
            , PCO_DOC_PDD_FINCA VARCHAR2(50 CHAR) 
            , PCO_DOC_PDD_ASIENTO VARCHAR2(50 CHAR) 
            , PCO_DOC_PDD_TOMO VARCHAR2(50 CHAR) 
            , PCO_DOC_PDD_LIBRO VARCHAR2(50 CHAR) 
            , PCO_DOC_PDD_FOLIO VARCHAR2(50 CHAR) 
            , PCO_DOC_PDD_NRO_FINCA VARCHAR2(50 CHAR) 
            , PCO_DOC_PDD_NRO_REGIS VARCHAR2(50 CHAR) 
            , PCO_DOC_PDD_PLAZA VARCHAR2(50 CHAR) 
            , PCO_DOC_PDD_IDUFIR VARCHAR2(50 CHAR) 
            , PCO_DOC_PDD_OBSERVACIONES VARCHAR2(250 CHAR) 
            , VERSION NUMBER(38, 0) DEFAULT 0 NOT NULL 
            , USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL 
            , FECHACREAR TIMESTAMP(6) NOT NULL 
            , USUARIOMODIFICAR VARCHAR2(50 CHAR) 
            , FECHAMODIFICAR TIMESTAMP(6) 
            , USUARIOBORRAR VARCHAR2(50 CHAR) 
            , FECHABORRAR TIMESTAMP(6) 
            , BORRADO NUMBER(1, 0) DEFAULT 0 NOT NULL 
            , PCO_DOC_PDD_EJECUTIVO VARCHAR2(2 CHAR) 
              )';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_ESQUEMA||'.'||V_TABLA||' creada.');       	
ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ya existe');
END IF;

-----------------------------------------------------------------------------------------------------------------------------------
V_TABLA :='AUX_STOCK_PRECON_SOL';
DBMS_OUTPUT.PUT_LINE('[INICIO] Crear tabla: '||V_ESQUEMA||'.'||V_TABLA||'...');
V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';

EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Creando tabla');
    V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'(
             PCO_SOL_SYS_GUID VARCHAR2(36 CHAR)  
            , DOC_SYS_GUID VARCHAR2(36 CHAR) NOT NULL 
            , DD_PCO_DSR_ID VARCHAR2(2 CHAR) 
            , DD_PCO_DSA_ID VARCHAR2(20 CHAR) NOT NULL 
            , PCO_DOC_DSO_FECHA_SOLICITUD TIMESTAMP(6) 
            , PCO_DOC_DSO_FECHA_ENVIO TIMESTAMP(6) 
            , PCO_DOC_DSO_FECHA_RESULTADO TIMESTAMP(6) 
            , PCO_DOC_DSO_FECHA_RECEPCION TIMESTAMP(6) 
            , VERSION NUMBER(38, 0) DEFAULT 0 NOT NULL 
            , USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL 
            , FECHACREAR TIMESTAMP(6) NOT NULL 
            , USUARIOMODIFICAR VARCHAR2(50 CHAR) 
            , FECHAMODIFICAR TIMESTAMP(6) 
            , USUARIOBORRAR VARCHAR2(50 CHAR) 
            , FECHABORRAR TIMESTAMP(6) 
            , BORRADO NUMBER(1, 0) DEFAULT 0 NOT NULL 
              )';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_ESQUEMA||'.'||V_TABLA||' creada.');    	
ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ya existe');
END IF;

-----------------------------------------------------------------------------------------------------------------------------------
V_TABLA :='AUX_STOCK_PRECON_BUR';
DBMS_OUTPUT.PUT_LINE('[INICIO] Crear tabla: '||V_ESQUEMA||'.'||V_TABLA||'...');
V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Creando tabla');
    V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'(
              PCO_BUR_SYS_GUID VARCHAR2(36 CHAR) NOT NULL 
            , PCO_PRC_SYS_GUID VARCHAR2(36 CHAR) NOT NULL 
            , PER_COD NUMBER(16,0) NOT NULL 
            , DD_PCO_BFE_ID VARCHAR2(20 CHAR) NOT NULL 
            , CNT_CONTRATO VARCHAR2(50 CHAR) 
            , DD_TIN_ID VARCHAR2(10 CHAR) 
            , SYS_GUID VARCHAR2(36 CHAR) 
            , VERSION NUMBER(38, 0) DEFAULT 0 NOT NULL 
            , USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL 
            , FECHACREAR TIMESTAMP(6) NOT NULL 
            , USUARIOMODIFICAR VARCHAR2(50 CHAR) 
            , FECHAMODIFICAR TIMESTAMP(6) 
            , USUARIOBORRAR VARCHAR2(50 CHAR) 
            , FECHABORRAR TIMESTAMP(6) 
            , BORRADO NUMBER(1, 0) DEFAULT 0 NOT NULL 
              )';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_ESQUEMA||'.'||V_TABLA||' creada.');    	
ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ya existe');
END IF;

-----------------------------------------------------------------------------------------------------------------------------------
V_TABLA :='AUX_STOCK_PRECON_ENV';

DBMS_OUTPUT.PUT_LINE('[INICIO] Crear tabla: '||V_ESQUEMA||'.'||V_TABLA||'...');
V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' and owner = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Creando tabla');
    V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'(
            PCO_ENV_SYS_GUID VARCHAR2(36 CHAR) ,
            BUR_SYS_GUID VARCHAR2(36 CHAR) NOT NULL ,
            DIR_COD VARCHAR2(33 BYTE) NOT NULL ,
            DD_PCO_BFT_ID VARCHAR2(40 CHAR) NOT NULL ,
            PCO_BUR_ENVIO_FECHA_SOLICITUD TIMESTAMP(6) ,
            PCO_BUR_ENVIO_FECHA_ENVIO TIMESTAMP(6) ,
            PCO_BUR_ENVIO_FECHA_ACUSO TIMESTAMP(6) ,
            DD_PCO_BFR_ID VARCHAR2(20 CHAR) ,
            PCO_BUR_ENVIO_CONTENIDO VARCHAR2(4000 BYTE) ,
            VERSION NUMBER(38, 0) DEFAULT 0 NOT NULL ,
            USUARIOCREAR VARCHAR2(50 CHAR) NOT NULL ,
            FECHACREAR TIMESTAMP(6) NOT NULL ,
            USUARIOMODIFICAR VARCHAR2(50 CHAR) ,
            FECHAMODIFICAR TIMESTAMP(6) ,
            USUARIOBORRAR VARCHAR2(50 CHAR) ,
            FECHABORRAR TIMESTAMP(6) ,
            BORRADO NUMBER(1, 0) DEFAULT 0 NOT NULL 
              )';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_ESQUEMA||'.'||V_TABLA||' creada.');    	
ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ya existe');
END IF;
-----------------------------------------------------------------------------------------------------------------------------------
COMMIT;

DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
     WHEN OTHERS THEN
          err_num := SQLCODE;
          err_msg := SQLERRM;

          DBMS_OUTPUT.PUT_LINE('KO no modificado');
          DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
          DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
          DBMS_OUTPUT.put_line(err_msg);

          ROLLBACK;
          RAISE;          

END;

/

EXIT
