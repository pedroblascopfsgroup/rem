--/*
--#########################################
--## AUTOR=Guillermo Llidó Parra
--## FECHA_CREACION=20180806
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=2.0.18
--## INCIDENCIA_LINK=REMVIP-1408
--## PRODUCTO=NO
--## 
--## Finalidad: 
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
--*/
--Para permitir la visualización de texto en un bloque PL/SQL utilizando DBMS_OUTPUT.PUT_LINE
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON;
SET DEFINE OFF;

CREATE OR REPLACE PROCEDURE #ESQUEMA#.SP_REPORT_STOCK_COOPER(SP_OUTPUT OUT VARCHAR2) AS

    V_ESQUEMA   	VARCHAR2(30 CHAR) := '#ESQUEMA#';
    V_ESQUEMA_M 	VARCHAR2(30 CHAR) := '#ESQUEMA_MASTER#';
    V_COUNT     	NUMBER(1);
    V_MSQL      	VARCHAR2(32767 CHAR);
    V_TABLA_MAIL 	VARCHAR2(30 CHAR) := 'INFORME_ENVIO_MAIL_COOPER';

    V_FROM 			VARCHAR2(100 CHAR) := 'noreply.rem@pfsgroup.es';
    V_TO 			VARCHAR2(100 CHAR) := 'daniel.albert@pfsgroup.es';
    V_BODY 			VARCHAR2(500 CHAR) := 'Se adjunta el informe diario del stock de COOPER.';
    V_CC 			VARCHAR2(500 CHAR) := 'guillermo.llido@pfsgroup.es';
    V_ASUNTO 		VARCHAR2(250 CHAR) := 'Informe REM del Stock de COOPER ';
    V_ADJUNTO 		VARCHAR2(250 CHAR) := 'Informe_stock_cartera_COOPER.xlsx';
    
BEGIN

    SP_OUTPUT := '[INICIO]' || CHR(10);

    --CREACION TABLAS MAIL
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA_MAIL||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_COUNT;
    IF V_COUNT = 1 THEN
        V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA_MAIL||' PURGE';
        EXECUTE IMMEDIATE V_MSQL;
        SP_OUTPUT := SP_OUTPUT || ' [INFO] Tabla '||V_TABLA_MAIL||' dropeada'||CHR(10);
    END IF;
    
    V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA_MAIL||' AS
       SELECT '''||V_FROM||''' DE, '''||V_TO||''' A, '''||V_CC||''' COPIA
       	, '''||V_BODY||''' CUERPO, '''||V_ASUNTO||''' || TO_CHAR(SYSDATE,''DD/MM/RR'') ASUNTO
       	, '''||V_ADJUNTO||''' ADJUNTO
       FROM DUAL';
    EXECUTE IMMEDIATE V_MSQL;
    SP_OUTPUT := SP_OUTPUT || ' [INFO] Tabla '||V_TABLA_MAIL||' creada'||CHR(10);

    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
      SP_OUTPUT := SP_OUTPUT||'[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(SQLCODE)||CHR(10);
      SP_OUTPUT := SP_OUTPUT||'-----------------------------------------------------------'||CHR(10);
      SP_OUTPUT := SP_OUTPUT||SQLERRM||CHR(10);
      SP_OUTPUT := SP_OUTPUT||V_MSQL||CHR(10);
      ROLLBACK;
      RAISE;
END SP_REPORT_STOCK_COOPER;
/
EXIT;
