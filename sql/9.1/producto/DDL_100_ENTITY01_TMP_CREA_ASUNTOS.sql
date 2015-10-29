--/*
--##########################################
--## AUTOR=CARLOS PEREZ
--## FECHA_CREACION=29-10-2015
--## ARTEFACTO=web
--## VERSION_ARTEFACTO=9.1
--## INCIDENCIA_LINK=CMREC-945
--## PRODUCTO=SI
--## Finalidad: DDL Creación de las tablas para la creación de asuntos ficticios para pruebas
--##           
--## INSTRUCCIONES: Configurar las variables necesarias en el principio del DECLARE
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/

WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;


DECLARE

    V_MSQL VARCHAR2(32000 CHAR); -- Sentencia a ejecutar    
    V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- Configuracion Esquema Master
    V_TS_INDEX VARCHAR2(25 CHAR):= '#TABLESPACE_INDEX#'; -- Configuracion Indice
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.  
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
    
    
    BEGIN
	      
    -- Comprobamos si existe la tabla   
     
    V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_CREA_ASUNTOS_NUEVOS'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la borramos
    IF V_NUM_TABLAS = 1 THEN 
			V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.TMP_CREA_ASUNTOS_NUEVOS';
			EXECUTE IMMEDIATE V_MSQL;
			DBMS_OUTPUT.PUT_LINE('[INFO] '||V_ESQUEMA||'.TMP_CREA_ASUNTOS_NUEVOS... Tabla borrada');  
    END IF;
    
    		  --Creamos la tabla
    V_MSQL := 'CREATE TABLE ' || V_ESQUEMA || '.TMP_CREA_ASUNTOS_NUEVOS 
   (	
   N_CASO VARCHAR2(50 BYTE) NOT NULL ENABLE, 
	 CREADO VARCHAR2(1 BYTE) DEFAULT ''N'' NOT NULL ENABLE,
	FECHA_ALTA DATE DEFAULT SYSDATE NOT NULL ENABLE, 
	N_REFERENCIA VARCHAR2(50 CHAR) NOT NULL ENABLE, 
	DESPACHO NUMBER(16,0) NOT NULL ENABLE, 
	LETRADO VARCHAR2(50 CHAR), 
	GRUPO VARCHAR2(10 CHAR), 
	TIPO_PROC NUMBER(16,0) NOT NULL ENABLE, 
	PROCURADOR VARCHAR2(30 CHAR) NOT NULL ENABLE, 
	PLAZA NUMBER(16,0) NOT NULL ENABLE, 
	JUZGADO NUMBER(16,0), 
	PRINCIPAL NUMBER(14,2) NOT NULL ENABLE, 
	ID NUMBER NOT NULL ENABLE, 
	VERSION NUMBER(10,0) DEFAULT 0 NOT NULL ENABLE, 
	N_LOTE VARCHAR2(50 BYTE), 
	LIN_ID NUMBER(16,0), 
	PRM_ID NUMBER, 
	DD_TAS_CODIGO VARCHAR2(50 BYTE),
  USD_ID_1 NUMBER(16,0),
  USU_USERNAME_TGE1 VARCHAR2(50 CHAR),
  DD_TGE_ID_1 NUMBER(16,0),
  USD_ID_2 NUMBER(16,0),  
  USU_USERNAME_TGE2 VARCHAR2(50 CHAR),
  DD_TGE_ID_2 NUMBER(16,0),
  USD_ID_3 NUMBER(16,0),
  USU_USERNAME_TGE3 VARCHAR2(50 CHAR),
  DD_TGE_ID_3 NUMBER(16,0)
   )';
  
  --DBMS_OUTPUT.PUT_LINE(V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] Tabla TMP_CREA_ASUNTOS_NUEVOS Creada');


/***************************************************/
/** CREAMOS LA TABLA INDICE PARA GENERAR ASUNTOS  **/
/***************************************************/

 V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_ASUNTOS_PARA_CREAR'' and owner = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
          EXECUTE IMMEDIATE 'DROP TABLE ' || V_ESQUEMA || '.TMP_ASUNTOS_PARA_CREAR';
          DBMS_OUTPUT.PUT_LINE('[INFO] Tabla TMP_ASUNTOS_PARA_CREAR Borrada');
    END IF;

V_MSQL := '  CREATE TABLE ' || V_ESQUEMA || '.TMP_ASUNTOS_PARA_CREAR 
   (	
  "N_CASO" VARCHAR2(50 BYTE) NOT NULL ENABLE, 
	"CNT_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"PER_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"OFI_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"CLI_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"EXP_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"PRC_ID" NUMBER(16,0) NOT NULL ENABLE, 
	"ASU_ID" NUMBER(16,0) NOT NULL ENABLE,
  "DD_TAS_CODIGO" VARCHAR2(50 BYTE),
  "DD_TIN_ID" NUMBER(16,0) NOT NULL ENABLE
   )';

  --DBMS_OUTPUT.PUT_LINE(V_MSQL);
  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] Tabla TMP_ASUNTOS_PARA_CREAR Creada');


/*************************************/
/** CREAR TABLA PARA GENERAR BPM'S  **/
/*************************************/

 
 
 V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = ''TMP_BPM_INPUT_CON1'' and owner = '''||V_ESQUEMA||'''';
 
    EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
    -- Si existe la tabla no hacemos nada
    IF V_NUM_TABLAS = 1 THEN 
          EXECUTE IMMEDIATE 'DROP TABLE ' || V_ESQUEMA || '.TMP_BPM_INPUT_CON1';
          DBMS_OUTPUT.PUT_LINE('[INFO] Tabla TMP_BPM_INPUT_CON1 Borrada');
    END IF;

  V_MSQL := '  CREATE TABLE ' || V_ESQUEMA || '.TMP_BPM_INPUT_CON1 
   (	"PRC_ID" NUMBER(16,0), 
	"TAP_ID" NUMBER, 
	"T_REFERENCIA" NUMBER(16,0)
   )';

  EXECUTE IMMEDIATE V_MSQL;
  DBMS_OUTPUT.PUT_LINE('[INFO] Tabla TMP_BPM_INPUT_CON1 Creada');
  
  DBMS_OUTPUT.PUT_LINE('[FIN] DDL_000_ENTITY_TMP_CREA_ASUNTOS');
      
  
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
