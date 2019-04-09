--/*
--######################################### 
--## AUTOR=Carles Molins
--## FECHA_CREACION=20190405
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=REMVIP-3846
--## PRODUCTO=NO
--## 
--## Finalidad: Alter tabla CLC_CLIENTE_COMERCIAL
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- Configuracion Esquema Master
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_EXISTS NUMBER(1);
    V_TABLA VARCHAR2(30 CHAR) := 'CLC_CLIENTE_COMERCIAL';

    TYPE T_CAMPOS IS TABLE OF VARCHAR2(150);      
    TYPE T_ARRAY_CAMPOS IS TABLE OF T_CAMPOS;          
    V_TEMP_CAMPOS T_CAMPOS;
    C_CAMPOS T_ARRAY_CAMPOS := T_ARRAY_CAMPOS(
    	T_CAMPOS('DD_TDI_ID_CONYUGE', 'NUMBER(16,0)', 'Tipo de documento del conyuge', '1', 'FK_DD_TDI_ID_CONYUGE_CLC', 'REM01.DD_TDI_TIPO_DOCUMENTO_ID', 'DD_TDI_ID'),
    	T_CAMPOS('CLC_DOCUMENTO_CONYUGE', 'VARCHAR2(14 CHAR)', 'Documento del conyuge', '0'),
        T_CAMPOS('DD_PAI_ID', 'NUMBER(16,0)', 'País del cliente', '1', 'FK_DD_PAI_ID_CLC', 'REM01.DD_PAI_PAISES', 'DD_PAI_ID'),
        T_CAMPOS('CLC_DIRECCION_RTE', 'VARCHAR2(100 CHAR)', 'Dirección del representante', '0'),
        T_CAMPOS('DD_PRV_ID_RTE', 'NUMBER(16,0)', 'Provincia del representante', '1', 'FK_DD_PRV_ID_RTE_CLC', 'REMMASTER.DD_PRV_PROVINCIA', 'DD_PRV_ID'),
        T_CAMPOS('DD_LOC_ID_RTE', 'NUMBER(16,0)', 'Municipio del representante', '1', 'FK_DD_LOC_ID_RTE_CLC', 'REMMASTER.DD_LOC_LOCALIDAD', 'DD_LOC_ID'),
        T_CAMPOS('DD_PAI_ID_RTE', 'NUMBER(16,0)', 'País del representante', '1', 'FK_DD_PAI_ID_RTE_CLC', 'REM01.DD_PAI_PAISES', 'DD_PAI_ID'),
        T_CAMPOS('CLC_CODIGO_POSTAL_RTE', 'NUMBER(16,0)', 'Código postal del representante', '0')
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
				
				IF V_TEMP_CAMPOS(4) = 1 THEN
					V_MSQL := 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' ADD CONSTRAINT '||V_TEMP_CAMPOS(5)||' FOREIGN KEY ('||V_TEMP_CAMPOS(1)||') REFERENCES '||V_TEMP_CAMPOS(6)||' ('||V_TEMP_CAMPOS(7)||')';
					EXECUTE IMMEDIATE V_MSQL;
					DBMS_OUTPUT.PUT_LINE('[INFO] FOREIGN KEY '||V_TEMP_CAMPOS(5)||' agregada a tabla '||V_TABLA||'.');
				END IF;
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
        DBMS_OUTPUT.put_line('[ERROR] Se ha producido un error en la ejecución:'||TO_CHAR(err_num));
        DBMS_OUTPUT.put_line('-----------------------------------------------------------'); 
        DBMS_OUTPUT.put_line(err_msg);
        ROLLBACK;
        RAISE;          
END;
/
EXIT
