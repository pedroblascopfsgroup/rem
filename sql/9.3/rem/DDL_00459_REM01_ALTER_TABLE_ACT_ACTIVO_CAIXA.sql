--/*
--######################################### 
--## AUTOR=Alejandra García
--## FECHA_CREACION=20210813
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.3
--## INCIDENCIA_LINK=HREOS-14839
--## PRODUCTO=NO
--## 
--## Finalidad: Borrar columnas de la tabla  ACT_ACTIVO_CAIXA
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
  V_TABLA VARCHAR2(2400 CHAR) := 'ACT_ACTIVO_CAIXA'; -- Vble. auxiliar para almacenar el nombre de la tabla de ref.

  TYPE T_TIPO_DATA IS TABLE OF VARCHAR2(150);
    TYPE T_ARRAY_DATA IS TABLE OF T_TIPO_DATA;
                  --DD_SCG_CODIGO        	--DD_ECG_CODIGO y IMPIDE_VENTA
    V_TIPO_DATA T_ARRAY_DATA := T_ARRAY_DATA(
        T_TIPO_DATA('CBX_ANYO_CONCES'),
        T_TIPO_DATA('CBX_FEC_FIN_CONCES')
		); 
    V_TMP_TIPO_DATA T_TIPO_DATA;


 
BEGIN

    DBMS_OUTPUT.PUT_LINE('[INICIO CAMPOS]');
        --Comprobacion de la tabla
        V_SQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||'''';
        EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
        
        IF V_NUM_TABLAS = 1 THEN     

            FOR I IN V_TIPO_DATA.FIRST .. V_TIPO_DATA.LAST
            LOOP
        
            V_TMP_TIPO_DATA := V_TIPO_DATA(I);    

                -- Verificar si el campo ya existe
                V_MSQL := 'SELECT COUNT(1) FROM ALL_TAB_COLUMNS WHERE OWNER = '''||V_ESQUEMA||''' AND TABLE_NAME = '''||V_TABLA||''' AND COLUMN_NAME = '''||TRIM(V_TMP_TIPO_DATA(1))||'''';
                EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS; 
                
                IF V_NUM_TABLAS = 1 THEN
                    DBMS_OUTPUT.PUT_LINE('  [INFO] Borrando Columna '||TRIM(V_TMP_TIPO_DATA(1))||'');  
                    EXECUTE IMMEDIATE 'ALTER TABLE '||V_ESQUEMA||'.'||V_TABLA||' DROP COLUMN '||TRIM(V_TMP_TIPO_DATA(1))||'';       
                ELSE
                    DBMS_OUTPUT.PUT_LINE('  [INFO] El campo '||V_TABLA||'.'||TRIM(V_TMP_TIPO_DATA(1))||'... No existe.');
                END IF;  

            END LOOP;  
        ELSE
            DBMS_OUTPUT.PUT_LINE('  [INFO] '||V_ESQUEMA||'.'||V_TABLA||'... No existe.');  
        END IF;

    
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
