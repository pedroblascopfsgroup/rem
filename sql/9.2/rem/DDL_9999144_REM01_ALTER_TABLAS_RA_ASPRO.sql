--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20180228
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.15
--## INCIDENCIA_LINK=REMVIP-156
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

    TYPE T_CAMPOS IS TABLE OF VARCHAR2(150);      
    TYPE T_ARRAY_CAMPOS IS TABLE OF T_CAMPOS;          
    V_TEMP_CAMPOS T_CAMPOS;
    C_CAMPOS T_ARRAY_CAMPOS := T_ARRAY_CAMPOS(
        T_CAMPOS('ASPRO_10_CABECERA','IMBAFA','NUMBER(15,2) DEFAULT (0)'),
        T_CAMPOS('ASPRO_12_INMOVILIZADO','IMNGAS','NUMBER(15,2) DEFAULT (0)')
    );

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Alter Tables');
    
    FOR I IN C_CAMPOS.FIRST .. C_CAMPOS.LAST
        LOOP
            V_TEMP_CAMPOS := C_CAMPOS(I);

            --COMPROBAMOS EXISTENCIA TABLA
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TEMP_CAMPOS(1)||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;

            IF V_EXISTS = 1 THEN
                --COMPROBAMOS EXISTENCIA COLUMNA
                V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_TEMP_CAMPOS(2)||''' AND TABLE_NAME = '''||V_TEMP_CAMPOS(1)||''' AND OWNER = '''||V_ESQUEMA||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
                
                IF V_EXISTS = 1 THEN
                    --MODIFICAMOS COLUMNA
                    V_MSQL := 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TEMP_CAMPOS(1);
                    EXECUTE IMMEDIATE V_MSQL;
                    V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TEMP_CAMPOS(1)||' MODIFY '||V_TEMP_CAMPOS(2)||' '||V_TEMP_CAMPOS(3)||'';
                    EXECUTE IMMEDIATE V_MSQL;
                    DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_TEMP_CAMPOS(2)||' modificada en tabla '||V_TEMP_CAMPOS(1)||'.');
                ELSE
                    DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la columna '||V_TEMP_CAMPOS(2)||' en la tabla '||V_TEMP_CAMPOS(1)||'.');
                END IF;
            ELSE
                DBMS_OUTPUT.PUT_LINE('[INFO] No existe la tabla '||V_TEMP_CAMPOS(1)||'');
            END IF;
    END LOOP;
    
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