--/*
--##########################################
--## AUTOR=MIGUEL ANGEL SANCHEZ
--## FECHA_CREACION=12-11-2015
--## ARTEFACTO=PCO_BUROFAX
--## VERSION_ARTEFACTO=1.0
--## INCIDENCIA_LINK=HR-1502
--## PRODUCTO=SI
--## Finalidad: DDL creacion tablas AUX_STOCK_LITIGIOS_ASU, AUX_STOCK_LITIGIOS_BIEPRC Y AUX_STOCK_LITIGIOS_PRCPER
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
    V_ENTIDAD_ID NUMBER(16);



BEGIN

-----------------------------------------------------------------------------------------------------------------------------------

DBMS_OUTPUT.PUT_LINE('[INICIO] Crear tabla: '||V_ESQUEMA||'.AUX_STOCK_LITIGIOS_ASU...');
V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_ESQUEMA||'.AUX_STOCK_LITIGIOS_ASU'' and owner = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Creando tabla');
    V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.AUX_STOCK_LITIGIOS_ASU(
                ID_ASUNTO NUMBER (16),
                SYS_GUID_ASUNTO VARCHAR (32 CHAR),
                NOMBRE_ASUNTO VARCHAR(100 CHAR),
                TPO_PRDC VARCHAR(20 CHAR),
                SYS_GUID_PRC VARCHAR (32 CHAR),
                CNT_CONTRATO VARCHAR(17 CHAR),
                SYS_GUID_CEX VARCHAR (32 CHAR),
                ESTADO_ASUNTO VARCHAR(20 CHAR),
                SYS_GUID_EXP VARCHAR(32 CHAR),
                SYS_GUID_PCO_PRC	VARCHAR2(36 CHAR),	 
                SYS_GUID_PCO_PRC_HEP	VARCHAR2(36 CHAR),
                EXP_ID NUMBER(16,0),
                ASU_ID NUMBER(16,0)
              )';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_ESQUEMA||'.AUX_STOCK_LITIGIOS_ASU creada.');    	
ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ya existe');
END IF;

-----------------------------------------------------------------------------------------------------------------------------------

DBMS_OUTPUT.PUT_LINE('[INICIO] Crear tabla: '||V_ESQUEMA||'.AUX_STOCK_LITIGIOS_BIEPRC...');
V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_ESQUEMA||'.AUX_STOCK_LITIGIOS_BIEPRC'' and owner = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Creando tabla');
    V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.AUX_STOCK_LITIGIOS_BIEPRC(
                ID_BIE_PRC NUMBER (16),
                SYS_GUID_BIE_PRC VARCHAR (32 CHAR),
                BIE_CODIGO_INTERNO NUMBER(16,0),
                SYS_GUID_PRC VARCHAR (32 CHAR)
              )';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_ESQUEMA||'.AUX_STOCK_LITIGIOS_BIEPRC creada.');    	
ELSE
    DBMS_OUTPUT.PUT_LINE('[INFO] La tabla ya existe');
END IF;

-----------------------------------------------------------------------------------------------------------------------------------

DBMS_OUTPUT.PUT_LINE('[INICIO] Crear tabla: '||V_ESQUEMA||'.AUX_STOCK_LITIGIOS_PRCPER...');
V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_ESQUEMA||'.AUX_STOCK_LITIGIOS_PRCPER'' and owner = '''||V_ESQUEMA||'''';
EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
IF V_NUM_TABLAS = 0 THEN
    DBMS_OUTPUT.PUT_LINE('[INFO] Creando tabla');
    V_SQL := 'CREATE TABLE '||V_ESQUEMA||'.AUX_STOCK_LITIGIOS_PRCPER(
                ID_PRC_PER NUMBER (16),
                PER_COD_CLIENTE VARCHAR(16 char),
                SYS_GUID_PRC VARCHAR (32 char)
              )';
    EXECUTE IMMEDIATE V_SQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_ESQUEMA||'.AUX_STOCK_LITIGIOS_PRCPER creada.');    	
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
