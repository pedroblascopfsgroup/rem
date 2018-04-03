--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180104
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=HREOS-3591
--## PRODUCTO=NO
--##
--## Finalidad: Actualización de activos traspasados (TANGO).   
--## INSTRUCCIONES:
--## VERSIONES:
--##        0.1 Versión inicial
--##########################################
--*/
WHENEVER SQLERROR EXIT SQL.SQLCODE;
SET SERVEROUTPUT ON; 
SET DEFINE OFF;

DECLARE

    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_MSQL VARCHAR2(2048 CHAR);
    V_TABLA VARCHAR2(30 CHAR) := 'AUX_ACTIVOS_TRASPASADOS';
    V_ESQUEMA VARCHAR2(15 CHAR) := 'REM01';
    V_EXISTS NUMBER(1);

BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
    
    IF V_EXISTS = 1 THEN
        V_MSQL := 'DROP TABLE '||V_ESQUEMA||'.'||V_TABLA||' PURGE';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] TABLA ELIMINADA');
    END IF;

    V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
        (ACT_NUM_ACTIVO_VIEJO VARCHAR2 (20 CHAR)
        , ACT_NUM_ACTIVO_NUEVO VARCHAR2 (20 CHAR)
        , CODIGO_CARTERA VARCHAR2 (50 CHAR)
        , CODIGO_SUBCARTERA VARCHAR2 (50 CHAR))';
    EXECUTE IMMEDIATE V_MSQL;
    DBMS_OUTPUT.PUT_LINE('[INFO] TABLA CREADA');
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');

EXCEPTION
    WHEN OTHERS THEN
        err_num := SQLCODE;
        err_msg := SQLERRM;
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);
        ROLLBACK;
        RAISE;          
END;
/
EXIT;