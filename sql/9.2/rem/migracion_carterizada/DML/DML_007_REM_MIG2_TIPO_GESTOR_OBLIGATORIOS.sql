--/*
--######################################### 
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20170229
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2043
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
    
    V_TABLA VARCHAR2(30 CHAR) := 'MIG2_TIPO_GESTOR_OBLIGATORIOS';  -- Tabla objetivo
    
    --Array que contiene los registros que se van a actualizar
    TYPE T_VAL is table of VARCHAR2(4000); 
    TYPE T_ARRAY_VAL IS TABLE OF T_VAL;
    V_VAL T_ARRAY_VAL := T_ARRAY_VAL(
        -- Cajamar
        T_VAL('AAII'   ,'01'    ,'GADM'),
        T_VAL('AAII'   ,'01'    ,'SUPADM'),
        T_VAL('AAII'   ,'01'    ,'GACT'),
        T_VAL('AAII'   ,'01'    ,'SUPACT'),
        T_VAL('AAII'   ,'01'    ,'GCOM'),
        T_VAL('AAII'   ,'01'    ,'SCOM'),
        T_VAL('AAII'   ,'01'    ,'GPREC'),
        T_VAL('AAII'   ,'01'    ,'GPUBL'),
        T_VAL('AAII'   ,'01'    ,'SPREC'),
        T_VAL('AAII'   ,'01'    ,'SPUBL'),
        T_VAL('AAII'   ,'01'    ,'GCBOINM'),
        T_VAL('AAII'   ,'01'    ,'SBOINM'),

        -- Sareb
        T_VAL('AAII'   ,'02'    ,'GADM'),
        T_VAL('AAII'   ,'02'    ,'SUPADM'),
        T_VAL('AAII'   ,'02'    ,'GACT'),
        T_VAL('AAII'   ,'02'    ,'SUPACT'),
        T_VAL('AAII'   ,'02'    ,'GGADM'),
        T_VAL('AAII'   ,'02'    ,'GCOM'),
        T_VAL('AAII'   ,'02'    ,'SCOM'),
        T_VAL('AAII'   ,'02'    ,'GPREC'),
        T_VAL('AAII'   ,'02'    ,'GPUBL'),
        T_VAL('AAII'   ,'02'    ,'SPREC'),
        T_VAL('AAII'   ,'02'    ,'SPUBL'),

        -- Bankia
        T_VAL('AAII'   ,'03'    ,'GADM'),
        T_VAL('AAII'   ,'03'    ,'SUPADM'),
        T_VAL('AAII'   ,'03'    ,'GACT'),
        T_VAL('AAII'   ,'03'    ,'SUPACT'),
        T_VAL('AAII'   ,'03'    ,'GGADM'),
        T_VAL('AAII'   ,'03'    ,'GCOM'),
        T_VAL('AAII'   ,'03'    ,'SCOM'),
        T_VAL('AAII'   ,'03'    ,'GPREC'),
        T_VAL('AAII'   ,'03'    ,'GPUBL'),
        T_VAL('AAII'   ,'03'    ,'SPREC'),
        T_VAL('AAII'   ,'03'    ,'SPUBL'),
        T_VAL('AAII'   ,'03'    ,'GCCBANKIA'),

        -- Cajamar
        T_VAL('AAFF'   ,'01'    ,'GCOM'),
        T_VAL('AAFF'   ,'01'    ,'SCOM'),
        T_VAL('AAFF'   ,'01'    ,'GPREC'),
        T_VAL('AAFF'   ,'01'    ,'GPUBL'),
        T_VAL('AAFF'   ,'01'    ,'SPREC'),
        T_VAL('AAFF'   ,'01'    ,'SPUBL'),
        T_VAL('AAFF'   ,'01'    ,'GCBOFIN'),
        T_VAL('AAFF'   ,'01'    ,'SBOFIN'),

        -- Sareb
        T_VAL('AAFF'   ,'02'    ,'GCOM'),
        T_VAL('AAFF'   ,'02'    ,'SCOM'),
        T_VAL('AAFF'   ,'02'    ,'GPREC'),
        T_VAL('AAFF'   ,'02'    ,'GPUBL'),
        T_VAL('AAFF'   ,'02'    ,'SPREC'),
        T_VAL('AAFF'   ,'02'    ,'SPUBL'),

        -- Bankia
        T_VAL('AAFF'   ,'03'    ,'GCOM'),
        T_VAL('AAFF'   ,'03'    ,'SCOM'),
        T_VAL('AAFF'   ,'03'    ,'GPREC'),
        T_VAL('AAFF'   ,'03'    ,'GPUBL'),
        T_VAL('AAFF'   ,'03'    ,'SPREC'),
        T_VAL('AAFF'   ,'03'    ,'SPUBL'),

        -- Cajamar
        T_VAL('ECO'   ,'01'    ,'GCOM'),
        T_VAL('ECO'   ,'01'    ,'SCOM'),
        T_VAL('ECO'   ,'01'    ,'GCBO'),
        T_VAL('ECO'   ,'01'    ,'GBACKOFFICE'),
        T_VAL('ECO'   ,'01'    ,'GFORM'),
        T_VAL('ECO'   ,'01'    ,'SFORM'),

        -- Sareb
        T_VAL('ECO'   ,'02'    ,'GCOM'),
        T_VAL('ECO'   ,'02'    ,'SCOM'),
        T_VAL('ECO'   ,'02'    ,'GFORM'),
        T_VAL('ECO'   ,'02'    ,'SFORM'),

        -- Bankia
        T_VAL('ECO'   ,'03'    ,'GCOM'),
        T_VAL('ECO'   ,'03'    ,'SCOM'),
        T_VAL('ECO'   ,'03'    ,'GFORM'),
        T_VAL('ECO'   ,'03'    ,'SFORM')
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
            
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE ELEMENTO_BASE = '''||V_TMP_VAL(1)||''' AND CARTERA = '''||V_TMP_VAL(2)||''' AND TIPO_GESTOR = '''||V_TMP_VAL(3)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 0 THEN
            
                DBMS_OUTPUT.PUT_LINE('      [INFO] Insertando ELEMENTO_BASE = '''||V_TMP_VAL(1)||''' AND CARTERA = '''||V_TMP_VAL(2)||''' AND TIPO_GESTOR = '''||V_TMP_VAL(3)||'''...');
                EXECUTE IMMEDIATE '
                INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                	ELEMENTO_BASE  
                	,CARTERA         
                	,TIPO_GESTOR            
                )
                SELECT
                	'''||V_TMP_VAL(1)||'''
                	, '''||V_TMP_VAL(2)||'''
                	, '''||V_TMP_VAL(3)||'''
                FROM DUAL
                '
                ;
            
            ELSE
                DBMS_OUTPUT.PUT_LINE('      [INFO] ELEMENTO_BASE = '''||V_TMP_VAL(1)||''' AND CARTERA = '''||V_TMP_VAL(2)||''' AND TIPO_GESTOR = '''||V_TMP_VAL(3)||'''... Existe.');
            END IF;
            
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
