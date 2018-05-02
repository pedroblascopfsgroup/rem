--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180425
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.16
--## INCIDENCIA_LINK=REMVIP-598
--## PRODUCTO=NO
--## Finalidad: CREAR TABLA
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
    V_ESQUEMA_M VARCHAR2(25 CHAR) := '#ESQUEMA_MASTER#';
    V_ESQUEMA_3 VARCHAR2(25 CHAR) := 'PFSREM';
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_EXISTS NUMBER(1);
    V_TABLA VARCHAR2(30 CHAR) := 'APR_AUX_STOCK_SIN_GESTORIA';

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Create Table '||V_TABLA||'');
    --COMPROBAMOS EXISTENCIA TABLA
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
    
    IF V_EXISTS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la tabla '||V_TABLA||'.');
    ELSE
        V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
           (ACTIVO_ID VARCHAR2(16 CHAR)
            , FECHACREAR TIMESTAMP
           )';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TABLA||' creada.');
    END IF;

    IF V_ESQUEMA_M != V_ESQUEMA THEN  
        EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_M||'" WITH GRANT OPTION';
        DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_M||''); 
    END IF;

    V_MSQL := 'SELECT COUNT(1) FROM ALL_USERS WHERE USERNAME = '''||V_ESQUEMA_3||''' ';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
    IF V_EXISTS = 1 THEN
        EXECUTE IMMEDIATE 'GRANT ALL ON "'||V_ESQUEMA||'"."'||V_TABLA||'" TO "'||V_ESQUEMA_3||'" WITH GRANT OPTION';
        DBMS_OUTPUT.PUT_LINE('[INFO] PERMISOS SOBRE LA TABLA '||V_ESQUEMA||'.'||V_TABLA||' OTORGADOS A '||V_ESQUEMA_3||''); 
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('KO no creada');
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);
        ROLLBACK;
        RAISE;          
END;
/
EXIT