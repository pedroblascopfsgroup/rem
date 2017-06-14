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
    
    V_TABLA VARCHAR2(30 CHAR) := 'VIC_VAL_INTERFAZ_PRO';  -- Tabla objetivo
    V_TABLA_SEQ VARCHAR2(30 CHAR) := 'S_VIC_VAL_INTERFAZ_PRO';  --  Sequencia de la tabla objetivo
    
    --Array que contiene los registros que se van a actualizar
    TYPE T_VAL is table of VARCHAR2(4000); 
    TYPE T_ARRAY_VAL IS TABLE OF T_VAL;
    V_VAL T_ARRAY_VAL := T_ARRAY_VAL(
        --Validaciones para ofertas
T_VAL('MIG2_CLC_CLIENTE_COMERCIAL','CLC_COD_CLIENTE_WEBCOM','CLC_CLIENTE_COMERCIAL','',1),
T_VAL('MIG2_VIS_VISITAS','','VIS_VISITAS','',1),
T_VAL('MIG2_OFR_OFERTAS','','OFR_OFERTAS','',1),
T_VAL('MIG2_OFA_OFERTAS_ACTIVO','','ACT_OFR','',1),
T_VAL('MIG2_COE_CONDICIONAN_OFR_ACEP','','COE_CONDICIONANTES_EXPEDIENTE','',1),
T_VAL('MIG2_RES_RESERVAS','','RES_RESERVAS','',1),
T_VAL('MIG2_OFR_TIA_TITULARES_ADI','','OFR_TIA_TITULARES_ADICIONALES','',1),
T_VAL('MIG2_COM_COMPRADORES','','COM_COMPRADOR','',1),
T_VAL('MIG2_CEX_COMPRADOR_EXPEDIENTE','','CEX_COMPRADOR_EXPEDIENTE','',1),
T_VAL('MIG2_GEX_GASTOS_EXPEDIENTE','','GEX_GASTOS_EXPEDIENTE','',1),
T_VAL('MIG2_OBF_OBSERVACIONES_OFERTAS','','TXO_TEXTOS_OFERTA','',1),
T_VAL('MIG2_FOR_FORMALIZACIONES','','FOR_FORMALIZACION','',1),
T_VAL('MIG2_POS_POSICIONAMIENTO','','POS_POSICIONAMIENTO','',1),
T_VAL('MIG2_SUB_SUBSANACIONES','','SUB_SUBSANACIONES','',1),
T_VAL('MIG2_ACT_HEP_HIST_EST_PUBLI','','ACT_HEP_HIST_EST_PUBLICACION','',1),
T_VAL('MIG2_ACT_COE_CONDICIONES_ESPEC','','ACT_COE_CONDICION_ESPECIFICA','',1),
T_VAL('MIG2_ACT_HVA_HIST_VALORACIONES','','ACT_HVA_HIST_VALORACIONES','',1),
T_VAL('MIG2_PRP_PROPUESTAS_PRECIOS','','PRP_PROPUESTAS_PRECIOS','',1),
T_VAL('MIG2_ACT_PRP','','ACT_PRP','',1),
T_VAL('MIG2_GPR_PROVISION_GASTOS','','PRG_PROVISION_GASTOS','',1),
T_VAL('MIG2_GPV_GASTOS_PROVEEDORES','','GPV_GASTOS_PROVEEDOR','',1),
T_VAL('MIG2_GPV_ACT_TBJ','','GPV_ACT','',1),
T_VAL('MIG2_GPV_ACT_TBJ','','GPV_TBJ','',1),
T_VAL('MIG2_GDE_GASTOS_DET_ECONOMICO','','GDE_GASTOS_DETALLE_ECONOMICO','',1),
T_VAL('MIG2_GGE_GASTOS_GESTION','','GGE_GASTOS_GESTION','',1),
T_VAL('MIG2_GIM_GASTOS_IMPUGNACION','','GIM_GASTOS_IMPUGNACION','',1),
T_VAL('MIG2_GIC_GASTOS_INFO_CONTABI','','GIC_GASTOS_INFO_CONTABILIDAD','',1),
T_VAL('MIG2_PAC_PERIMETRO_ACTIVO','','ACT_PAC_PERIMETRO_ACTIVO','',1),
T_VAL('MIG2_ACT_ACTIVO','ACT_NUMERO_ACTIVO','ACT_ACTIVO','ACT_NUM_ACTIVO',1),
T_VAL('MIG2_ACQ_ACTIVO_ALQUILER','ACQ_NUMERO_ACTIVO','ACT_ACTIVO','ACT_NUM_ACTIVO',1),
T_VAL('MIG2_AGR_AGRUPACIONES','AGR_UVEM','ACT_AGR_AGRUPACION','AGR_NUM_AGRUP_UVEM',0),
T_VAL('MIG_CPC_PROP_CABECERA','CPR_COD_COM_PROP_UVEM','ACT_CPR_COM_PROPIETARIOS','CPR_COD_COM_PROP_UVEM',0),
T_VAL('MIG2_PVE_PROVEEDORES','','ACT_PVE_PROVEEDOR','',1),
T_VAL('MIG_ACA_CABECERA','ACT_NUMERO_ACTIVO','ACT_ACTIVO','ACT_NUM_ACTIVO',0),
T_VAL('MIG_ADA_DATOS_ADI','ACT_NUMERO_ACTIVO','ACT_ACTIVO','ACT_NUM_ACTIVO',0),
T_VAL('MIG_ATI_TITULO','ACT_NUMERO_ACTIVO','ACT_ACTIVO','ACT_NUM_ACTIVO',0),
T_VAL('MIG_APC_PRECIO','','ACT_VAL_VALORACIONES','',1),
T_VAL('MIG_APL_PLANDINVENTAS','ACT_NUMERO_ACTIVO','ACT_ACTIVO','ACT_NUM_ACTIVO',0),
T_VAL('MIG_ADJ_JUDICIAL','ACT_NUMERO_ACTIVO','ACT_ACTIVO','ACT_NUM_ACTIVO',0),
T_VAL('MIG_ADJ_NO_JUDICIAL','ACT_NUMERO_ACTIVO','ACT_ACTIVO','ACT_NUM_ACTIVO',0),
T_VAL('MIG_ACA_CARGAS_ACTIVO','ACT_NUMERO_ACTIVO','ACT_ACTIVO','ACT_NUM_ACTIVO',0),
T_VAL('MIG_ATA_TASACIONES_ACTIVO','ACT_NUMERO_ACTIVO','ACT_ACTIVO','ACT_NUM_ACTIVO',0),
T_VAL('MIG2_PRO_PROPIETARIOS','','ACT_PRO_PROPIETARIO','',1),
T_VAL('MIG_APC_PROP_CABECERA','','ACT_PRO_PROPIETARIO','',1),
T_VAL('MIG_APA_PROP_ACTIVO','','ACT_PAC_PROPIETARIO_ACTIVO','',1),
T_VAL('MIG_AIA_INFCOMERCIAL_ACT','','ACT_ICO_INFO_COMERCIAL','',1),
T_VAL('MIG_AID_INFCOMERCIAL_DISTR','','ACT_DIS_DISTRIBUCION','',1),
T_VAL('MIG_ACA_CALIDADES_ACTIVO','','ACT_ACTIVO','',1),
T_VAL('MIG_AAG_AGRUPACIONES','AGR_UVEM','ACT_AGR_AGRUPACION','AGR_NUM_AGRUP_UVEM',0),
T_VAL('MIG_AAA_AGRUPACION_ACTIVO','','ACT_AGA_AGRUPACION_ACTIVO','',1),
T_VAL('MIG_AOA_OBSERVACION_AGRUP','AGR_UVEM','ACT_AGR_AGRUPACION','AGR_NUM_AGRUP_UVEM',0),
T_VAL('MIG_ACA_CATASTRO_ACTIVO','ACT_NUMERO_ACTIVO','ACT_ACTIVO','ACT_NUM_ACTIVO',0),
T_VAL('MIG_ALA_LLAVES_ACTIVO','ACT_NUMERO_ACTIVO','ACT_ACTIVO','ACT_NUM_ACTIVO',0),
T_VAL('MIG_AML_MOVIMIENTOS_LLAVE','LLV_CODIGO_UVEM','ACT_LLV_LLAVE','LLV_NUM_LLAVE',0),
T_VAL('MIG2_PRD_PROVEEDOR_DIRECCION','PVE_COD_UVEM','ACT_PVE_PROVEEDOR','PVE_COD_UVEM',0),
T_VAL('MIG2_PVC_PROVEEDOR_CONTACTO','PVE_COD_UVEM','ACT_PVE_PROVEEDOR','PVE_COD_UVEM',0),
T_VAL('MIG_AEP_ENTIDAD_PROVEEDOR','','ACT_ETP_ENTIDAD_PROVEEDOR','',1),
T_VAL('MIG_ATR_TRABAJO','','ACT_ACTIVO','',1),
T_VAL('MIG_APT_PRESUPUESTO_TRABAJ','TBJ_NUM_TRABAJO','ACT_TBJ_TRABAJO','TBJ_NUM_TRABAJO',0),
T_VAL('MIG_ADD_ADMISION_DOC','ACT_NUMERO_ACTIVO','ACT_ACTIVO','ACT_NUM_ACTIVO',0),
T_VAL('MIG2_USU_USUARIOS','USU_USERNAME','REMMASTER.USU_USUARIOS','USU_USERNAME',0)
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
