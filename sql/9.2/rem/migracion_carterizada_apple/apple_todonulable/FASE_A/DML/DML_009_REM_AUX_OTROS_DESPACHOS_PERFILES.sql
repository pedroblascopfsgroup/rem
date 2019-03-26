--/*
--######################################### 
--## AUTOR=MANUEL RODRIGUEZ
--## FECHA_CREACION=20170530
--## ARTEFACTO=batch
--## VERSION_ARTEFACTO=9.2
--## INCIDENCIA_LINK=HREOS-2204
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
    
    V_TABLA VARCHAR2(30 CHAR) := 'MIG2_DESPACHOS_PERFILES';  -- Tabla objetivo
    
    --Array que contiene los registros que se van a actualizar
    TYPE T_VAL is table of VARCHAR2(4000); 
    TYPE T_ARRAY_VAL IS TABLE OF T_VAL;
    V_VAL T_ARRAY_VAL := T_ARRAY_VAL(
        -- CODIGO_DESPACHO ------ CODIGO_PERFIL --
        T_VAL('REMCERT'         , 'HAYACERTI'),
        T_VAL('REMSUPER'        , 'HAYASUPER'),
        T_VAL('REMSUPADM'       , 'HAYASUPADM'),
        T_VAL('REMSUPACT'       , 'HAYASUPACT'),
        T_VAL('REMGGADM'        , 'GESTOADM'),
        T_VAL('REMADM'          , 'HAYAGESTADM'),
        T_VAL('REMACT'          , 'HAYAGESACT'),
        T_VAL('REMPROV'         , 'HAYAPROV'),
        T_VAL('GESTORIAFORM'    , 'GESTIAFORM'),
        T_VAL('GESTCOMBACKOFF'  , 'GESTCOMBACKOFFICE'),
        T_VAL('REMGPREC'        , 'HAYAGESTPREC'),
        T_VAL('REMGMARK'        , 'HAYAGESTMARK'),
        T_VAL('REMGPUBL'        , 'HAYAGESTPUBL'),
        T_VAL('REMGCOM'         , 'HAYAGESTCOM'),
        T_VAL('REMGFORM'        , 'HAYAGESTFORM'),
        T_VAL('REMSUPPREC'      , 'HAYASUPPREC'),
        T_VAL('REMSUPMARK'      , 'HAYASUPMARK'),
        T_VAL('REMSUPPUBL'      , 'HAYASUPPUBL'),
        T_VAL('REMSUPCOM'       , 'HAYASUPCOM'),
        T_VAL('REMSUPFORM'      , 'HAYASUPFORM'),
        T_VAL('REMGCOMRET'      , 'HAYAGESTCOMRET'),
        T_VAL('REMGCOMSIN'      , 'HAYAGESTCOMSIN'),
        T_VAL('REMSUPCOMRET'    , 'HAYASUPCOMRET'),
        T_VAL('REMSUPCOMSIN'    , 'HAYASUPCOMSIN'),
        T_VAL('REMGCCBANKIA'    , 'PERFGCCBANKIA'),
        T_VAL('REMGIAADMT'      , 'HAYAGESTADMT'),
        T_VAL('REMCAL'          , 'HAYACAL'),
        T_VAL('REMSUPCAL'       , 'HAYASUPCAL'),
        T_VAL('REMFSV'          , 'HAYAFSV'),
        T_VAL('REMBACKOFFICE'   , 'HAYABACKOFFICE'),
        T_VAL('HAYAADM'         , 'HAYAADM'),
        T_VAL('HAYASADM'        , 'HAYASADM'),
        T_VAL('HAYALLA'         , 'HAYALLA'),
        T_VAL('HAYASLLA'        , 'HAYASLLA'),
        T_VAL('GESTOCED'        , 'GESTOCED'),
        T_VAL('GESTOPLUS'       , 'GESTOPLUS'),
        T_VAL('GESTOPDV'        , 'GESTOPDV')
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
            
            V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE CODIGO_DESPACHO = '''||V_TMP_VAL(1)||''' AND CODIGO_PERFIL = '''||V_TMP_VAL(2)||'''';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
            
            IF V_NUM_TABLAS = 0 THEN
            
                DBMS_OUTPUT.PUT_LINE('      [INFO] Insertando CODIGO_DESPACHO = '''||V_TMP_VAL(1)||''' AND CODIGO_PERFIL = '''||V_TMP_VAL(2)||'''...');
                EXECUTE IMMEDIATE '
                INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                	CODIGO_DESPACHO  
                	,CODIGO_PERFIL         
                )
                SELECT
                	'''||V_TMP_VAL(1)||'''
                	, '''||V_TMP_VAL(2)||'''
                FROM DUAL
                '
                ;
            
            ELSE
                DBMS_OUTPUT.PUT_LINE('      [INFO] CODIGO_DESPACHO = '''||V_TMP_VAL(1)||''' AND CODIGO_PERFIL = '''||V_TMP_VAL(2)||'''... Existe.');
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
