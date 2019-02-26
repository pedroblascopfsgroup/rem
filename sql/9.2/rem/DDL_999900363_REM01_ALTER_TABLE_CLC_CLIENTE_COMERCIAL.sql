--/*
--######################################### 
--## AUTOR=Miguel Ángel cortés Gil
--## FECHA_CREACION=20181031
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-4673
--## PRODUCTO=NO
--## 
--## Finalidad: Alter tabla de CLC_CESION_DATOS, CLC_TRANSF_INTER,CLC_COMUNI_TERCEROS  ---> CLC_CLIENTE_COMERCIAL
--##            
--## INSTRUCCIONES:  
--## VERSIONES:
--##        0.1 Versión inicial
--#########################################
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
    V_TABLA VARCHAR2(30 CHAR) := 'CLC_CLIENTE_COMERCIAL';

    TYPE T_CAMPOS IS TABLE OF VARCHAR2(150);      
    TYPE T_ARRAY_CAMPOS IS TABLE OF T_CAMPOS;          
    V_TEMP_CAMPOS T_CAMPOS;
    C_CAMPOS T_ARRAY_CAMPOS := T_ARRAY_CAMPOS(
        T_CAMPOS('CLC_CESION_DATOS',	'NUMBER(1,0)',	'bool datos del comprador'     			),
        T_CAMPOS('CLC_TRANSF_INTER',	'NUMBER(1,0)',  'bool Transferencias internacionales'    	),
        T_CAMPOS('CLC_COMUNI_TERCEROS',	'NUMBER(1,0)',	'bool comunicación terceros'   			)
    );

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Alter Table '||V_TABLA||'');
    --COMPROBAMOS EXISTENCIA TABLA
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
    
    IF V_EXISTS = 1 THEN
        --COMPROBAMOS EXISTENCIA COLUMNA
        FOR I IN C_CAMPOS.FIRST .. C_CAMPOS.LAST
        LOOP
            V_TEMP_CAMPOS:= C_CAMPOS(I);
            V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = '''||V_TEMP_CAMPOS(1)||''' AND TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
            
            IF V_EXISTS = 0 THEN
                --CREAMOS COLUMNA
                V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD '||V_TEMP_CAMPOS(1)||' '||V_TEMP_CAMPOS(2)||'';
                EXECUTE IMMEDIATE V_MSQL;
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_TEMP_CAMPOS(1)||' IS '''||V_TEMP_CAMPOS(3)||'''';
                DBMS_OUTPUT.PUT_LINE('[INFO] Columna '||V_TEMP_CAMPOS(1)||' agregada a tabla '||V_TABLA||'.');
            ELSE
		EXECUTE IMMEDIATE 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TABLA||'.'||V_TEMP_CAMPOS(1)||' IS '''||V_TEMP_CAMPOS(3)||'''';
                DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la columna '||V_TEMP_CAMPOS(1)||' en la tabla '||V_TABLA||'.');
            END IF;
        END LOOP;
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
