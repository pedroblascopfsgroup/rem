--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.12
--## INCIDENCIA_LINK=HREOS-3535
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
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_EXISTS NUMBER(1);
    V_TABLA VARCHAR2(30 CHAR) := 'APR_AUX_UPDATE_BIE_ADJ';

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Alter Table '||V_TABLA||'');
    --COMPROBAMOS EXISTENCIA TABLA
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
    
    IF V_EXISTS = 1 THEN
        DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la tabla '||V_TABLA||'.');
    ELSE
        V_MSQL := 'CREATE TABLE '||V_ESQUEMA||'.'||V_TABLA||'
           (BIE_ID NUMBER(16,0) NOT NULL ENABLE 
            , BIE_ADJ_F_SOL_POSESION DATE
            , BIE_ADJ_F_SEN_POSESION DATE
            , BIE_ADJ_F_REA_POSESION DATE
            , BIE_ADJ_LANZAMIENTO_NECES NUMBER(1)
            , BIE_ADJ_F_SEN_LANZAMIENTO DATE
            , BIE_ADJ_F_REA_LANZAMIENTO DATE
            , BIE_ADJ_F_SOL_MORATORIA DATE
            , DD_FAV_CODIGO VARCHAR2(20 CHAR)
            , BIE_ADJ_F_RES_MORATORIA DATE
           )';
        EXECUTE IMMEDIATE V_MSQL;
        DBMS_OUTPUT.PUT_LINE('[INFO] Tabla '||V_TABLA||' creada.');
    END IF;
    
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