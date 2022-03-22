--/*
--######################################### 
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20210908
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14861
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir columnas y FK a tabla CLC_CLIENTE_COMERCIAL, COM_COMPRADOR y CEX_COMPRADOR_EXPEDIENTE
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
  V_ESQUEMA VARCHAR2(25 CHAR):= '#ESQUEMA#'; -- #ESQUEMA# Configuracion Esquema
  V_ESQUEMA_M VARCHAR2(25 CHAR):= '#ESQUEMA_MASTER#'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
  V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.
  V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.    
  ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
  ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.

    
  --Array que contiene las columnas que se van a crear
  TYPE T_COL IS TABLE OF VARCHAR2(250);
  TYPE T_ARRAY_COL IS TABLE OF T_COL;
  V_COL T_ARRAY_COL := T_ARRAY_COL(
    T_COL('CREATE_COLUMN', 'CLC_CLIENTE_COMERCIAL', 'DD_TOC_ID', 'NUMBER(16,0)', 'Identificador único del diccionario de Ocupación'),
    T_COL('ADD_CONSTRAINT', 'CLC_CLIENTE_COMERCIAL', 'FK_DD_TOC_ID', 'DD_TOC_ID', 'DD_TOC_TIPO_OCUPACION', 'DD_TOC_ID'),
    T_COL('CREATE_COLUMN', 'CLC_CLIENTE_COMERCIAL', 'CLC_NOMBRE_REPRESENTANTE', 'VARCHAR2(250 CHAR)', 'Nombre del Representante/Administrador'),
    T_COL('CREATE_COLUMN', 'CLC_CLIENTE_COMERCIAL', 'CLC_APELLIDOS_REPRESENTANTE', 'VARCHAR2(250 CHAR)', 'Apellidos del Representante/Administrador'),
    T_COL('CREATE_COLUMN', 'CLC_CLIENTE_COMERCIAL', 'CLC_TELEFONO_REPRESENTANTE', 'VARCHAR2(20 CHAR)', 'Telefono del Representante/Administrador'),
    T_COL('CREATE_COLUMN', 'CLC_CLIENTE_COMERCIAL', 'CLC_EMAIL_REPRESENTANTE', 'VARCHAR2(50 CHAR)', 'Email del Representante/Administrador'),
    T_COL('CREATE_COLUMN', 'CLC_CLIENTE_COMERCIAL', 'CLC_NOMBRE_CONTACTO', 'VARCHAR2(250 CHAR)', 'Nombre del Contacto'),
    T_COL('CREATE_COLUMN', 'CLC_CLIENTE_COMERCIAL', 'CLC_APELLIDOS_CONTACTO', 'VARCHAR2(250 CHAR)', 'Apellidos del Contacto'),
    T_COL('CREATE_COLUMN', 'CLC_CLIENTE_COMERCIAL', 'DD_TDI_ID_CONTACTO', 'NUMBER(16,0)', 'Identificador único del diccionario de Documento de Identificación referente al Contacto'),
    T_COL('ADD_CONSTRAINT', 'CLC_CLIENTE_COMERCIAL', 'FK_TIPO_IDENTIF_CONT', 'DD_TDI_ID_CONTACTO', 'DD_TDI_TIPO_DOCUMENTO_ID', 'DD_TDI_ID'),
    T_COL('CREATE_COLUMN', 'CLC_CLIENTE_COMERCIAL', 'CLC_DOCUMENTO_CONTACTO', 'VARCHAR2(14 CHAR)', 'Documento identificador del Contacto'),
    T_COL('CREATE_COLUMN', 'CLC_CLIENTE_COMERCIAL', 'CLC_TELEFONO_CONTACTO', 'VARCHAR2(20 CHAR)', 'Telefono del Contacto'),
    T_COL('CREATE_COLUMN', 'CLC_CLIENTE_COMERCIAL', 'CLC_EMAIL_CONTACTO', 'VARCHAR2(50 CHAR)', 'Email del Contacto'),
    T_COL('CREATE_COLUMN', 'CLC_CLIENTE_COMERCIAL', 'ID_CLIENTE_REM_REPRESENTANTE', 'NUMBER(16,0)', 'Identificador único del Representante del Cliente REM'),
    T_COL('CREATE_COLUMN', 'CLC_CLIENTE_COMERCIAL', 'ID_CLIENTE_CONTACTO', 'NUMBER(16,0)', 'Identificador único del Contacto del Cliente'),
    T_COL('CREATE_COLUMN', 'COM_COMPRADOR', 'DD_TOC_ID', 'NUMBER(16,0)', 'Identificador único del diccionario de Ocupación'),
    T_COL('ADD_CONSTRAINT', 'COM_COMPRADOR', 'FK_DD_TOC_ID_COM', 'DD_TOC_ID', 'DD_TOC_TIPO_OCUPACION', 'DD_TOC_ID'),
    T_COL('CREATE_COLUMN', 'CEX_COMPRADOR_EXPEDIENTE', 'CEX_NOMBRE_CONTACTO', 'VARCHAR2(250 CHAR)', 'Nombre del Contacto'),
    T_COL('CREATE_COLUMN', 'CEX_COMPRADOR_EXPEDIENTE', 'CEX_APELLIDOS_CONTACTO', 'VARCHAR2(250 CHAR)', 'Apellidos del Contacto'),
    T_COL('CREATE_COLUMN', 'CEX_COMPRADOR_EXPEDIENTE', 'DD_TDI_ID_CONTACTO', 'NUMBER(16,0)', 'Identificador único del diccionario de Documento de Identificación referente al Contacto'),
    T_COL('ADD_CONSTRAINT', 'CEX_COMPRADOR_EXPEDIENTE', 'FK_TIPO_IDENTIF_CONT_CEX', 'DD_TDI_ID_CONTACTO', 'DD_TDI_TIPO_DOCUMENTO_ID', 'DD_TDI_ID'),
    T_COL('CREATE_COLUMN', 'CEX_COMPRADOR_EXPEDIENTE', 'CEX_DOCUMENTO_CONTACTO', 'VARCHAR2(14 CHAR)', 'Documento identificador del Contacto'),
    T_COL('CREATE_COLUMN', 'CEX_COMPRADOR_EXPEDIENTE', 'CEX_TELEFONO_CONTACTO', 'VARCHAR2(20 CHAR)', 'Telefono del Contacto'),
    T_COL('CREATE_COLUMN', 'CEX_COMPRADOR_EXPEDIENTE', 'CEX_EMAIL_CONTACTO', 'VARCHAR2(50 CHAR)', 'Email del Contacto'),
    T_COL('CREATE_COLUMN', 'CEX_COMPRADOR_EXPEDIENTE', 'ID_CLIENTE_REM_REPRESENTANTE', 'NUMBER(16,0)', 'Identificador único del Representante del Cliente REM'),
    T_COL('CREATE_COLUMN', 'CEX_COMPRADOR_EXPEDIENTE', 'ID_CLIENTE_CONTACTO', 'NUMBER(16,0)', 'Identificador único del Contacto del Cliente')
  );  
  V_TMP_COL T_COL;

 
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO CAMPOS]');
    
    FOR I IN V_COL.FIRST .. V_COL.LAST
    LOOP
        V_TMP_COL := V_COL(I);

        IF 'CREATE_COLUMN' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [CREATE_COLUMN]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                -- Verificar si el campo ya existe
                V_MSQL := 'SELECT COUNT(*) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||''' AND COLUMN_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                
                IF V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo Columna '||V_TMP_COL(3)||'');
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' ADD '||V_TMP_COL(3)||' '||V_TMP_COL(4)||''; 

                    V_MSQL := 'COMMENT ON COLUMN '||V_ESQUEMA||'.'||V_TMP_COL(2)||'.'||V_TMP_COL(3)||' IS '''||V_TMP_COL(5)||'''';
                    EXECUTE IMMEDIATE V_MSQL;
                    DBMS_OUTPUT.PUT_LINE('[INFO] Comentario de la columna '||V_TMP_COL(3)||' creado.');      
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TMP_COL(2)||'.'||V_TMP_COL(3)||'... ya existe.');
                END IF;    
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] '||V_ESQUEMA||'.'||V_TMP_COL(2)||'... No existe.');  
            END IF;
        END IF;

        IF 'ADD_CONSTRAINT' = ''||V_TMP_COL(1)||'' THEN
            DBMS_OUTPUT.PUT_LINE('  [ADD_CONSTRAINT]');
            --Comprobacion de la tabla
            V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TMP_COL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 1 THEN              
                V_MSQL := 'SELECT COUNT(1) FROM ALL_CONSTRAINTS WHERE TABLE_NAME = '''||V_TMP_COL(2)||''' AND CONSTRAINT_NAME = '''||V_TMP_COL(3)||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                IF V_NUM_TABLAS = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Añadiendo FK '||V_TMP_COL(3)||'');  
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TMP_COL(2)||' ADD CONSTRAINT '||V_TMP_COL(3)||' FOREIGN KEY('||V_TMP_COL(4)||') REFERENCES '||V_TMP_COL(5)||'('||V_TMP_COL(6)||')';
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] La restricción '||V_TMP_COL(3)||' ya existe.');
                END IF;          
            ELSE
                DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_TMP_COL(2)||'... No existe.');
            END IF;    
        END IF;
    
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');
    
    COMMIT;  
    
EXCEPTION
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('KO!');
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
