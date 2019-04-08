--/*
--######################################### 
--## AUTOR=DAP
--## FECHA_CREACION=20170530
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
    
    V_TABLA VARCHAR2(30 CHAR) := 'VALIDACIONES_DUPLICADOS';  -- Tabla objetivo
    V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_VALIDACIONES_DUPLICADOS';  --  Sequencia de la tabla objetivo
    
    --Array que contiene los registros que se van a actualizar
    TYPE T_VAL is table of VARCHAR2(4000); 
    TYPE T_ARRAY_VAL IS TABLE OF T_VAL;
    V_VAL T_ARRAY_VAL := T_ARRAY_VAL
    (
        /*
          1er bloque: Activos y Agrupaciones
        */
        --NOTA: Reutilizaremos internamente (en BBDD) los campos *_UVEM aunque de cara al cliente son otro campo.
        --ACTIVOS
        T_VAL('MIG_ACA_CABECERA','ACT_NUMERO_ACTIVO','ACT_ACTIVO','ACT_NUM_ACTIVO',0),
        --T_VAL('MIG_CPC_PROP_CABECERA','CPR_COD_COM_PROP_EXTERNO','ACT_CPR_COM_PROPIETARIOS','CPR_COD_COM_PROP_UVEM',0),
        T_VAL('MIG_APC_PROP_CABECERA','PRO_CODIGO','ACT_PRO_PROPIETARIO','PRO_CODIGO_UVEM',0),
        T_VAL('MIG2_USU_USUARIOS','USU_USERNAME','REMMASTER.USU_USUARIOS','USU_USERNAME',0)
        --AGRUPACIONES
        --T_VAL('MIG_AAG_AGRUPACIONES','AGR_EXTERNO','ACT_AGR_AGRUPACION','AGR_NUM_AGRUP_UVEM',0)
        /*
          Resto de bloques:   
        T_VAL('MIG2_OFR_OFERTAS','OFR_COD_OFERTA','OFR_OFERTAS','OFR_NUM_OFERTA',0),
        T_VAL('MIG2_CLC_CLIENTE_COMERCIAL','CLC_COD_CLIENTE_WEBCOM','CLC_CLIENTE_COMERCIAL','CLC_WEBCOM_ID',0),
        T_VAL('MIG2_VIS_VISITAS','VIS_COD_VISITA_WEBCOM','VIS_VISITAS','VIS_WEBCOM_ID',0),
        T_VAL('MIG2_RES_RESERVAS','RES_COD_NUM_RESERVA','RES_RESERVA','RES_NUM_RESERVA',0),
        T_VAL('MIG2_PRP_PROPUESTAS_PRECIOS','PRP_NUM_PROPUESTA','PRP_PROPUESTAS_PRECIOS','PRP_NUM_PROPUESTA',0),
        T_VAL('MIG2_COM_COMPRADORES','COM_DOCUMENTO','COM_COMPRADOR','COM_DOCUMENTO',0),
        T_VAL('MIG2_GPV_GASTOS_PROVEEDORES','GPV_ID','GPV_GASTOS_PROVEEDOR','GPV_NUM_GASTO_HAYA',0)
        */
    );  
    V_TMP_VAL T_VAL; 
    
BEGIN
  
    DBMS_OUTPUT.PUT_LINE('[INICIO]');
    
    -- Verificar si la tabla existe
    V_MSQL := 'SELECT COUNT(1) FROM ALL_TABLES WHERE TABLE_NAME = '''||V_TABLA||''' AND OWNER = '''||V_ESQUEMA||'''';
    EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
    
    IF V_NUM_TABLAS > 0 THEN    
        DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA|| '.'||V_TABLA||'... Existe.');
        DBMS_OUTPUT.PUT_LINE('  [INFO] La tabla '||V_ESQUEMA|| '.'||V_TABLA||'... Existe.');
        
        -- Verificar si la sequencia existe
        V_MSQL := 'SELECT COUNT(1) FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = '''||V_TABLA_SEQ||''' AND SEQUENCE_OWNER = '''||V_ESQUEMA||'''';
        EXECUTE IMMEDIATE V_MSQL INTO V_NUM_TABLAS;   
        
        IF V_NUM_TABLAS > 0 THEN
            
            EXECUTE IMMEDIATE 'TRUNCATE TABLE '||V_ESQUEMA||'.'||V_TABLA;
            DBMS_OUTPUT.PUT_LINE('    [INFO] La sequencia '||V_ESQUEMA|| '.'||V_TABLA_SEQ||'... Existe.');
            
            -- Comprobamos el estado de la sequencia
            -- Obtenemos el valor en el que se encuentra la sequencia
            V_SQL := 'SELECT '||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_SEQUENCE;
            
            -- Obtenemos el maximo valor de ID
            V_SQL := 'SELECT NVL(MAX(VALIDACION_ID), 0) FROM '||V_ESQUEMA||'.'||V_TABLA||'';
            EXECUTE IMMEDIATE V_SQL INTO V_NUM_MAXID;
            
            -- Igualamos la sequencia al maximo valor de ID
            WHILE V_NUM_SEQUENCE < V_NUM_MAXID LOOP
                EXECUTE IMMEDIATE 'SELECT '||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL FROM DUAL';
            END LOOP;
    
            FOR I IN V_VAL.FIRST .. V_VAL.LAST 
            LOOP
                V_TMP_VAL := V_VAL(I);  
                
                    EXECUTE IMMEDIATE '
                    INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                    	VALIDACION_ID  
                    	,NOMBRE_INTERFAZ
						,CAMPOS_INTERFAZ
						,NOMBRE_PRODUCCION
						,CAMPOS_PRODUCCION
						,BORRADO       
                    )
                    SELECT
                    	'||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL
                    	, '''||V_TMP_VAL(1)||'''
                    	, '''||V_TMP_VAL(2)||'''
                    	, '''||V_TMP_VAL(3)||'''
                    	, '''||V_TMP_VAL(4)||'''
                    	, '||V_TMP_VAL(5)||'
                    FROM DUAL
                    '
                    ;
                
            END LOOP;
        
        ELSE
            DBMS_OUTPUT.PUT_LINE('    [INFO] La sequencia '||V_ESQUEMA|| '.'||V_TABLA_SEQ||'... No existe.');
        END IF;  
    
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
