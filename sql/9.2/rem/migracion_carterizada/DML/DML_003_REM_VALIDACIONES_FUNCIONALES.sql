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
    
    V_TABLA VARCHAR2(30 CHAR) := 'VIC_VAL_INTERFAZ_FUNC';  -- Tabla objetivo
    V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_VIC_VAL_INTERFAZ_FUNC';  --  Sequencia de la tabla objetivo
    
    --Array que contiene los registros que se van a actualizar
    TYPE T_VAL is table of VARCHAR2(4000); 
    TYPE T_ARRAY_VAL IS TABLE OF T_VAL;
    V_VAL T_ARRAY_VAL := T_ARRAY_VAL(
        --- CODIGO -------- SEVERIDAD ---- VALIDACION ---------------------------------------------------------------------------------------------------------------------------------------------------------- NOMBRE_INTERFAZ ------- QUERY --------------------------------------
        
        --Validaciones para ofertas
        T_VAL('OFR_001'   ,'1'           ,'Ofertas en estado distinto a anulación con motivo de anulación informado'                                                                                           ,'MIG2_OFR_OFERTAS'     ,'select #SELECT_STATEMENT# from REM01.MIG2_OFR_OFERTAS migofr where migofr.OFR_COD_ESTADO_OFERTA != ''''01-07'''' and migofr.OFR_COD_MOTIVO_ANULACION !=0'),
        T_VAL('OFR_002'   ,'1'           ,'Ofertas que o bien se solicita financiación y no está informada la entidad financiadora o bien no se solicita y viene informada'                                    ,'MIG2_OFR_OFERTAS'     ,'select #SELECT_STATEMENT# from REM01.MIG2_OFR_OFERTAS ofr join REM01.MIG2_COE_CONDICIONAN_OFR_ACEP coe on ofr.OFR_COD_OFERTA = coe.COE_COD_OFERTA where (coe.COE_SOLICITA_FINANCIACION = 1 and coe.COE_ENTIDAD_FINANCIACION_AJENA is null) or ((coe.COE_SOLICITA_FINANCIACION = 0 or coe.COE_SOLICITA_FINANCIACION is null) and coe.COE_ENTIDAD_FINANCIACION_AJENA is not null)'),
        T_VAL('OFR_003'   ,'1'           ,'Ofertas aceptadas SIN importes'                                                                                                                                     ,'MIG2_OFR_OFERTAS'     ,'select #SELECT_STATEMENT# from REM01.MIG2_OFR_OFERTAS migofr where migofr.OFR_COD_ESTADO_OFERTA != ''''01-07'''' and migofr.OFR_COD_MOTIVO_ANULACION !=0'),
        T_VAL('OFR_004'   ,'1'           ,'Ofertas que o bien se solicita financiación y no está informada la entidad financiadora o bien no se solicita y viene informada'                                    ,'MIG2_OFR_OFERTAS'     ,'select #SELECT_STATEMENT# from REM01.MIG2_OFR_OFERTAS migofr where migofr.OFR_COD_ESTADO_OFERTA LIKE ''''01%'''' and migofr.OFR_IMPORTE is null'),
        T_VAL('OFR_005'   ,'1'           ,'Ofertas con contraoferta SIN importe contraoferta o fecha de contraoferta'                                                                                          ,'MIG2_OFR_OFERTAS'     ,'select #SELECT_STATEMENT# from REM01.MIG2_OFR_OFERTAS migofr where migofr.OFR_COD_ESTADO_OFERTA = ''''01-04'''' and ((migofr.OFR_IMPORTE_CONTRAOFERTA is null and migofr.OFR_FECHA_CONTRAOFERTA is not null) or (migofr.OFR_IMPORTE_CONTRAOFERTA is not null and migofr.OFR_FECHA_CONTRAOFERTA is null))'),
        
        --Validaciones para activos
        T_VAL('ACT_001'   ,'1'           ,'Activos vendidos, no deben estar en perímetro'                                                                                                                      ,'MIG_ACA_CABECERA'     ,'select #SELECT_STATEMENT# from REM01.MIG_ACA_CABECERA act where EXISTS (select pac.PAC_NUMERO_ACTIVO from REM01.MIG2_PAC_PERIMETRO_ACTIVO pac) and act.SITUACION_COMERCIAL = ''''05'''''),
        T_VAL('ACT_002'   ,'1'           ,'Activos en estado "Disponible para la venta con oferta" creados por la migración que no posean fecha de venta externa o oferta en estado distinto a "rechazada"'    ,'MIG_ACA_CABECERA'     ,'select #SELECT_STATEMENT# from REM01.MIG_ACA_CABECERA act inner join REM01.MIG2_OFA_OFERTAS_ACTIVO ofa on act.ACT_NUMERO_ACTIVO = ofa.OFA_ACT_NUMERO_ACTIVO inner join REM01.MIG2_ACT_ACTIVO act2 on act.ACT_NUMERO_ACTIVO = act2.ACT_NUMERO_ACTIVO inner join REM01.MIG2_OFR_OFERTAS ofr on ofa.OFA_COD_OFERTA = ofr.OFR_COD_OFERTA where act.SITUACION_COMERCIAL= ''''03'''' and (act2.ACT_FECHA_VENTA is null and ofr.OFR_COD_ESTADO_OFERTA != ''''02'''')'),
        T_VAL('ACT_003'   ,'1'           ,'Activos en estado "Disponible para la venta con reserva" creados por la migración que no dispongan de reserva'                                                      ,'MIG_ACA_CABECERA'     ,'select #SELECT_STATEMENT# from REM01.MIG_ACA_CABECERA act where NOT EXISTS (select ofa.OFA_ACT_NUMERO_ACTIVO from REM01.MIG2_OFA_OFERTAS_ACTIVO ofa inner join REM01.MIG2_RES_RESERVAS res on ofa.OFA_COD_OFERTA = res.RES_COD_OFERTA) and act.SITUACION_COMERCIAL= ''''04'''''),
        T_VAL('ACT_004'   ,'1'           ,'Activos sin título posesorio'                                                                                                                                       ,'MIG_ACA_CABECERA'     ,'select #SELECT_STATEMENT# from REM01.MIG_ACA_CABECERA act where act.TIPO_TITULO is null')
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
                
                V_SQL := 'SELECT COUNT(1) FROM '||V_ESQUEMA||'.'||V_TABLA||' WHERE CODIGO = '''||V_TMP_VAL(1)||''' AND BORRADO = 0';
                EXECUTE IMMEDIATE V_SQL INTO V_NUM_TABLAS;
                
                IF V_NUM_TABLAS = 0 THEN
                
                    DBMS_OUTPUT.PUT_LINE('      [INFO] Insertando validación: '''||V_TMP_VAL(3)||'''...');
                    EXECUTE IMMEDIATE '
                    INSERT INTO '||V_ESQUEMA||'.'||V_TABLA||' (
                    	VALIDACION_ID  
                    	,CODIGO         
                    	,SEVERIDAD      
                    	,VALIDACION     
                    	,NOMBRE_INTERFAZ
                    	,QUERY          
                    	,BORRADO        
                    )
                    SELECT
                    	'||V_ESQUEMA||'.'||V_TABLA_SEQ||'.NEXTVAL
                    	, '''||V_TMP_VAL(1)||'''
                    	, '''||V_TMP_VAL(2)||'''
                    	, '''||V_TMP_VAL(3)||'''
                    	, '''||V_TMP_VAL(4)||'''
                    	, '''||V_TMP_VAL(5)||'''
                    	, 0
                    FROM DUAL
                    '
                    ;
                
                ELSE
                    DBMS_OUTPUT.PUT_LINE('      [INFO] La validacion '''||V_TMP_VAL(3)||'''... Existe.');
                END IF;
                
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
