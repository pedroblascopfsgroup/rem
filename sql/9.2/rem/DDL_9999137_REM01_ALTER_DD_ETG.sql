--/*
--##########################################
--## AUTOR=DAP
--## FECHA_CREACION=20171201
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=2.0.10
--## INCIDENCIA_LINK=HREOS-3217
--## PRODUCTO=NO
--## Finalidad: AÑADIR COLUMNA TIPO PROVEEDOR A TABLA DD_ETG_EQV_TIPO_GASTO_RU
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
    V_TABLA VARCHAR2(30 CHAR) := 'DD_ETG_EQV_TIPO_GASTO_RU';
    V_KEY VARCHAR2(30 CHAR) := 'FK_ETQ_TPR';

BEGIN
    
    DBMS_OUTPUT.PUT_LINE('[INICIO] Alter Table '||V_TABLA||'');
    --COMPROBAMOS EXISTENCIA TABLA
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
    
    IF V_EXISTS = 1 THEN
        --COMPROBAMOS EXISTENCIA COLUMNA
        V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE COLUMN_NAME = ''DD_TPR_ID'' AND TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
        
        IF V_EXISTS = 0 THEN
            --CREAMOS COLUMNA
            V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD DD_TPR_ID NUMBER(16)';
            EXECUTE IMMEDIATE V_MSQL;
            DBMS_OUTPUT.PUT_LINE('[INFO] Columna DD_TPR_ID agregada a tabla '||V_TABLA||'.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la columna DD_TPR_ID en la tabla '||V_TABLA||'.');
        END IF;
        --COMPROBAMOS EXISTENCIA DE FK SOBRE CAMPO
        V_MSQL := 'SELECT COUNT(1) 
            FROM SYS.ALL_CONS_COLUMNS T1 
            JOIN SYS.ALL_CONSTRAINTS T2 ON T1.CONSTRAINT_NAME = T2.CONSTRAINT_NAME 
            WHERE T1.TABLE_NAME = '''||V_TABLA||'''
                AND T2.CONSTRAINT_TYPE = ''R''
                AND T1.COLUMN_NAME = ''DD_TPR_ID'' 
                AND T1.POSITION = 1
                AND T1.OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
        
        IF V_EXISTS = 0 THEN
            --COMPROBAMOS EXISTENCIA DE FK CON MISMO NOMBRE
            V_MSQL := V_MSQL||' AND T1.CONSTRAINT_NAME = '''||V_KEY||'''';
            EXECUTE IMMEDIATE V_MSQL INTO V_EXISTS;
            
            IF V_EXISTS = 0 THEN
                --SI NO EXISTE FK CON MISMO NOMBRE SOBRE CAMPO SE CREA
                V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' 
                    ADD CONSTRAINT '||V_KEY||' 
                    FOREIGN KEY (DD_TPR_ID) 
                    REFERENCES '||V_ESQUEMA||'.DD_TPR_TIPO_PROVEEDOR (DD_TPR_ID)';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] Clave foránea '||V_KEY||' creada.');
            ELSE
                --SI EXISTE NOMBRE FK PERO NO FK SOBRE CAMPO SE INTENTARÁ CREAR CON OTRO NOMBRE
                V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' 
                    ADD CONSTRAINT '||V_KEY||'2 
                    FOREIGN KEY (DD_TPR_ID) 
                    REFERENCES '||V_ESQUEMA||'.'||V_TABLA||' (DD_TPR_ID)';
                EXECUTE IMMEDIATE V_MSQL;
                DBMS_OUTPUT.PUT_LINE('[INFO] Clave foránea '||V_KEY||'2 creada.');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('[INFO] Ya existe la clave foránea sobre el campo DD_TPR_ID.');
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