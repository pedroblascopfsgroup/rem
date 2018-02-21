--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180220
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.14
--## INCIDENCIA_LINK=REMVIP-86
--## PRODUCTO=NO
--## Finalidad: AÑADIR COLUMNAS
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
    V_TABLA VARCHAR2(30 CHAR) := 'ACT_PRO_PROPIETARIO';
    V_CAMPO VARCHAR2(128 CHAR) := 'PRO_SOCIEDAD_PAGADORA'; -- Nuevo Campo
    V_TIPO_CAMPO VARCHAR2(128 CHAR) := 'VARCHAR2(200 CHAR)'; -- Tipo Campo
BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] ALTER TABLE '||V_TABLA||'');
    --COMPROBAMOS EXISTENCIA TABLA
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
    
    IF V_EXISTS = 1 THEN
        --COMPROBAMOS EXISTENCIA COLUMNA
        V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_CAMPO||''' AND TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
        
        IF V_EXISTS = 0 THEN
            --CREAMOS COLUMNA
            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_CAMPO||' '||V_TIPO_CAMPO||'';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_CAMPO||' agregada a tabla '||V_TABLA||'.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la columna '||V_CAMPO||' en la tabla '||V_TABLA||'.');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('[INFO] No existe la tabla '||V_TABLA||'');
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
