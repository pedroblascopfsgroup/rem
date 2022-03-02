--/*
--######################################### 
--## AUTOR=Alejandro Valverde
--## FECHA_CREACION=20210908
--## ARTEFACTO=online
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14860
--## PRODUCTO=NO
--## 
--## Finalidad: Añadir columnas y FK a tabla OFR_OFERTAS
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
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_HAYA_HOME_ID', 'NUMBER(16,0)', 'Identificador de id de oferta de HAYA HOME'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_ORIGEN_OFERTA', 'VARCHAR2(5 CHAR)', 'Origen de la oferta'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_MESES_CARENCIA', 'NUMBER(16,2)', 'Meses de carencia'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_CONTRATO_RESERVA', 'NUMBER(1,0)', 'Posee contrato de reserva'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_MOTIVO_CONGELACION', 'VARCHAR2(250 CHAR)', 'Motivo de la congelacionde la oferta'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_IBI', 'NUMBER(1,0)', 'Impuesto sobre Bienes Inmuebles'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_IMPORTE_IBI', 'NUMBER(16,2)', 'Importe del Impuesto sobre Bienes Inmuebles'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_OTRAS_TASAS', 'NUMBER(1,0)', 'Otras tasas'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_IMPORTE_OTRAS_TASAS', 'NUMBER(16,2)', 'Importe de las otras tasas'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_CCPP', 'NUMBER(1,0)', 'Posee CCPP'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_IMPORTE_CCPP', 'NUMBER(16,2)', 'Importe CCPP'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_PORCENTAJE_1_ANYO', 'NUMBER(16,2)', '% 1er año'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_PORCENTAJE_2_ANYO', 'NUMBER(16,2)', '% 2do año'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_PORCENTAJE_3_ANYO', 'NUMBER(16,2)', '% 3er año'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_PORCENTAJE_4_ANYO', 'NUMBER(16,2)', '% 4to año'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_MESES_CARENCIA_CTRAOFR', 'NUMBER(16,2)', 'Meses de carencia de la contraoferta'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_PORCENTAJE_1_ANYO_CTRAOFR', 'NUMBER(16,2)', '% 1er año de la contraoferta'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_PORCENTAJE_2_ANYO_CTRAOFR', 'NUMBER(16,2)', '% 2do año de la contraoferta'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_PORCENTAJE_3_ANYO_CTRAOFR', 'NUMBER(16,2)', '% 3er año de la contraoferta'),
    T_COL('CREATE_COLUMN', 'OFR_OFERTAS', 'OFR_PORCENTAJE_4_ANYO_CTRAOFR', 'NUMBER(16,2)', '% 4to año de la contraoferta')
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
