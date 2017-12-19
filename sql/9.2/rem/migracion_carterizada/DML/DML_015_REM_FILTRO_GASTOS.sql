--/*
--######################################### 
--## AUTOR=DAP
--## FECHA_CREACION=20171017
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2042
--## PRODUCTO=NO
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
    V_ESQUEMA VARCHAR2(25 CHAR):= 'REM01'; -- #ESQUEMA# Configuracion Esquema
    V_ESQUEMA_M VARCHAR2(25 CHAR):= 'REMMASTER'; -- #ESQUEMA_MASTER# Configuracion Esquema Master
    V_TABLESPACE_IDX VARCHAR2(25 CHAR):= 'REM_IDX'; -- #TABLESPACE_INDEX# Configuracion Tablespace de Indices
    V_SQL VARCHAR2(4000 CHAR); -- Vble. para consulta que valida la existencia de una tabla.  
    V_NUM_TABLAS NUMBER(16); -- Vble. para validar la existencia de una tabla.     
    ERR_NUM NUMBER(25);  -- Vble. auxiliar para registrar errores en el script.
    ERR_MSG VARCHAR2(1024 CHAR); -- Vble. auxiliar para registrar errores en el script.
    V_NUM_SEQUENCE NUMBER(16); --Vble .aux para almacenar el valor de la sequencia
    V_NUM_MAXID NUMBER(16); --Vble .aux para almacenar el valor maximo de ID
    
    V_TABLA VARCHAR2(30 CHAR) := 'MIG_AUX_GASTOS_FILTRO';  -- Tabla objetivo
    
    --Array que contiene los registros que se van a actualizar
    TYPE T_VAL is table of VARCHAR2(4000); 
    TYPE T_ARRAY_VAL IS TABLE OF T_VAL;
    V_VAL T_ARRAY_VAL := T_ARRAY_VAL(
        --Validaciones para ofertas
    --TGA  TPR  STG  PRI
T_VAL('01','13',null,'0'),
T_VAL('01','15',null,'0'),
T_VAL('02','13',null,'0'),
T_VAL('02','16',null,'0'),
T_VAL('03','13',null,'0'),
T_VAL('03','17',null,'0'),
T_VAL('04','13',null,'0'),
T_VAL('04','16',null,'0'),
T_VAL('04','17',null,'0'),
T_VAL('05','07',null,'1'),
T_VAL('06','08',null,'1'),
T_VAL('07','10',null,'1'),
T_VAL('08','12',null,'1'),
T_VAL('09','25',null,'2'),
T_VAL('10','03',null,'2'),
T_VAL('11','02','51','2'),
T_VAL('11','05','50','2'),
T_VAL('11','19','45','2'),
T_VAL('11','19','95','2'),
T_VAL('11','19','96','2'),
T_VAL('11','19','46','2'),
T_VAL('11','19','47','2'),
T_VAL('11','19','48','2'),
T_VAL('11','19','49','2'),
T_VAL('11','19','52','2'),
T_VAL('11','21','44','2'),
T_VAL('11','24','43','2'),
T_VAL('12','01',null,'2'),
T_VAL('13','04','55','2'),
T_VAL('13','18','56','2'),
T_VAL('14','01','60','2'),
T_VAL('14','01','63','2'),
T_VAL('14','01','64','2'),
T_VAL('14','01','65','2'),
T_VAL('14','01','66','2'),
T_VAL('14','01','67','2'),
T_VAL('14','05','57','2'),
T_VAL('14','05','59','2'),
T_VAL('14','05','61','2'),
T_VAL('14','05','62','2'),
T_VAL('14','05','68','2'),
T_VAL('14','05','69','2'),
T_VAL('14','06','58','2'),
T_VAL('15','05',null,'2'),
T_VAL('16','05',null,'2'),
T_VAL('17','27',null,'2'),
T_VAL('18','27',null,'2'),
T_VAL(null,'01',null,'3')
    );  
    V_TMP_VAL T_VAL; 
    
BEGIN
  
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    -- Verificar si la tabla existe
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
    
    IF V_NUM_TABLAS > 0 THEN    
        DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA|| '.'||V_TABLA||'... Existe.');
    
            FOR I IN V_VAL.FIRST .. V_VAL.LAST 
            LOOP
                V_TMP_VAL := V_VAL(I);  
                
                    EXECUTE IMMEDIATE '
                    INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
						DD_TGA_CODIGO
						,DD_TPR_CODIGO
						,DD_STG_CODIGO
                        ,PRIORIDAD
                    )
                    SELECT
                    	'''||V_TMP_VAL(1)||'''
                    	, '''||V_TMP_VAL(2)||'''
                    	, '''||V_TMP_VAL(3)||'''
                        , '||V_TMP_VAL(4)||'
                    FROM DUAL
                    '
                    ;
                
            END LOOP;
    
    ELSE
        DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA|| '.'||V_TABLA||'... No existe.');
    END IF;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('[FIN]');    

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
