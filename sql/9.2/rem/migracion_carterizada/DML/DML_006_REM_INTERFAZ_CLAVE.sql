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
    
    V_TABLA VARCHAR2(30 CHAR) := 'INTERFAZ_CLAVE';  -- Tabla objetivo
    
    --Array que contiene los registros que se van a actualizar
    TYPE T_VAL is table of VARCHAR2(4000); 
    TYPE T_ARRAY_VAL IS TABLE OF T_VAL;
    V_VAL T_ARRAY_VAL := T_ARRAY_VAL(
        --Validaciones para ofertas
T_VAL('MIG_ACA_CABECERA','ACT_NUMERO_ACTIVO','0'),
T_VAL('MIG_ATI_TITULO','ACT_NUMERO_ACTIVO','0'),
T_VAL('MIG_APL_PLANDINVENTAS','ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG_APL_PLANDINVENTAS','PDV_ACREEDOR_NUM_EXP','2'),
T_VAL('MIG_APL_PLANDINVENTAS','PDV_TIPO_PRODUCTO_ACTIVO','3'),
T_VAL('MIG_ADJ_JUDICIAL','ACT_NUMERO_ACTIVO','0'),
T_VAL('MIG_ADJ_NO_JUDICIAL','ACT_NUMERO_ACTIVO','0'),
T_VAL('MIG_CPC_PROP_CABECERA','CPR_COD_COM_PROP_UVEM','0'),
T_VAL('MIG_ADA_DATOS_ADI','ACT_NUMERO_ACTIVO','0'),
T_VAL('MIG2_PRO_PROPIETARIOS','PRO_PROPIETARIO_CODIGO_UVEM','0'),
T_VAL('MIG_APC_PROP_CABECERA','PRO_CODIGO_UVEM','1'),
T_VAL('MIG_APA_PROP_ACTIVO','ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG_ACA_CATASTRO_ACTIVO','ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG_ASA_SUBDIVISIONES_AGRUP','AGR_UVEM','0'),
T_VAL('MIG_ALA_LLAVES_ACTIVO','ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG_ALA_LLAVES_ACTIVO','LLV_CODIGO_UVEM','2'),
T_VAL('MIG_AML_MOVIMIENTOS_LLAVE','LLV_CODIGO_UVEM','1'),
T_VAL('MIG_AML_MOVIMIENTOS_LLAVE','MLV_CODIGO_MOVI_UVEM','2'),
T_VAL('MIG_ATA_TASACIONES_ACTIVO','ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG_AIA_INFCOMERCIAL_ACT','ACT_NUMERO_ACTIVO','0'),
T_VAL('MIG_ACA_CALIDADES_ACTIVO','ACT_NUMERO_ACTIVO','0'),
T_VAL('MIG_AID_INFCOMERCIAL_DISTR','ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG_AIC_IMAGENES_CABECERA','FOT_COD_FOTO_UVEM','0'),
T_VAL('MIG_ADD_ADMISION_DOC','TIPO_DOCUMENTO','2'),
T_VAL('MIG_AAA_AGRUPACION_ACTIVO','AGR_UVEM','2'),
T_VAL('MIG_ADA_DOCUMENTOS_ACTIVO','ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG_AAA_AGRUPACION_ACTIVO','ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG_AAG_AGRUPACIONES','AGR_UVEM','0'),
T_VAL('MIG2_PVE_PROVEEDORES','PVE_COD_UVEM','0'),
--T_VAL('MIG_APT_PRESUPUESTO_TRABAJO','PVE_DOCIDENTIF','2'),
T_VAL('MIG_ADA_DOCUMENTOS_ACTIVO','ADA_COD_DOC_UVEM','2'),
T_VAL('MIG_CPC_PROP_CUOTAS','CCP_COD_CUOTA_UVEM','0'),
T_VAL('MIG_AEP_ENTIDAD_PROVEEDOR','PVE_DOCIDENTIF','0'),
T_VAL('MIG_ATR_TRABAJO','ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG_ATR_TRABAJO','TBJ_NUM_TRABAJO','2'),
--T_VAL('MIG_APT_PRESUPUESTO_TRABAJO','TBJ_NUM_TRABAJO','1'),
T_VAL('MIG_APS_PROVISION_SUPLIDO','TBJ_NUM_TRABAJO','0'),
T_VAL('MIG2_PVC_PROVEEDOR_CONTACTO','PVE_COD_UVEM','1'),
T_VAL('MIG2_PVC_PROVEEDOR_CONTACTO','PVC_DOCUMENTO','2'),
T_VAL('MIG_APC_PRECIO','ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG_APC_PRECIO','TIPO_PRECIO','2'),
T_VAL('MIG_APC_PRECIO','VAL_FECHA_INICIO','3'),
T_VAL('MIG_ADD_ADMISION_DOC','ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG_ATA_TASACIONES_ACTIVO','TAS_CODIGO_TASA_UVEM','2'),
T_VAL('MIG2_PRD_PROVEEDOR_DIRECCION','PVD_COD_DIRECCION','1'),
T_VAL('MIG2_CLC_CLIENTE_COMERCIAL','CLC_COD_CLIENTE_WEBCOM','0'),
T_VAL('MIG2_VIS_VISITAS','VIS_COD_VISITA_WEBCOM','0'),
T_VAL('MIG2_OFR_OFERTAS','OFR_COD_OFERTA','0'),
T_VAL('MIG2_OFA_OFERTAS_ACTIVO','OFA_COD_OFERTA','1'),
T_VAL('MIG2_OFA_OFERTAS_ACTIVO','OFA_ACT_NUMERO_ACTIVO','2'),
T_VAL('MIG2_COE_CONDICIONAN_OFR_ACEP','COE_COD_OFERTA','0'),
T_VAL('MIG2_RES_RESERVAS','RES_COD_NUM_RESERVA','0'),
T_VAL('MIG2_OFR_TIA_TITULARES_ADI','OFR_TIA_COD_OFERTA','1'),
T_VAL('MIG2_OFR_TIA_TITULARES_ADI','OFR_TIA_COD_TIPO_DOC_TITUL_ADI','2'),
T_VAL('MIG2_OFR_TIA_TITULARES_ADI','OFR_TIA_DOCUMENTO','3'),
T_VAL('MIG2_COM_COMPRADORES','COM_COD_COMPRADOR','0'),
T_VAL('MIG2_CEX_COMPRADOR_EXPEDIENTE','CEX_COD_OFERTA','1'),
T_VAL('MIG2_GEX_GASTOS_EXPEDIENTE','GEX_COD_OFERTA','1'),
T_VAL('MIG2_GEX_GASTOS_EXPEDIENTE','GEX_COD_CONCEPTO_GASTO','2'),
T_VAL('MIG2_GEX_GASTOS_EXPEDIENTE','GEX_COD_PROVEEDOR','3'),
T_VAL('MIG2_GEX_GASTOS_EXPEDIENTE','GEX_ACT_NUMERO_ACTIVO','4'),
T_VAL('MIG2_OBF_OBSERVACIONES_OFERTAS','OBF_COD_OFERTA','1'),
T_VAL('MIG2_FOR_FORMALIZACIONES','FOR_COD_OFERTA','0'),
T_VAL('MIG2_POS_POSICIONAMIENTO','POS_COD_OFERTA','1'),
T_VAL('MIG2_POS_POSICIONAMIENTO','POS_COD_NOTARIO','2'),
T_VAL('MIG2_POS_POSICIONAMIENTO','POS_FECHA_AVISO','3'),
T_VAL('MIG2_POS_POSICIONAMIENTO','POS_FECHA_POSICIONAMIENTO','4'),
T_VAL('MIG2_POS_POSICIONAMIENTO','POS_MOTIVO_APLAZAMIENTO','5'),
T_VAL('MIG2_SUB_SUBSANACIONES','SUB_COD_OFERTA','0'),
T_VAL('MIG2_ACT_HEP_HIST_EST_PUBLI','HEP_ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG2_ACT_HEP_HIST_EST_PUBLI','HEP_FECHA_DESDE','2'),
T_VAL('MIG2_ACT_HEP_HIST_EST_PUBLI','HEP_FECHA_HASTA','3'),
T_VAL('MIG2_ACT_COE_CONDICIONES_ESPEC','COE_ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG2_ACT_HVA_HIST_VALORACIONES','HVA_ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG2_ACT_HVA_HIST_VALORACIONES','HVA_COD_TIPO_PRECIO','2'),
T_VAL('MIG2_ACT_HVA_HIST_VALORACIONES','HVA_FECHA_INICIO','3'),
T_VAL('MIG2_ACT_HVA_HIST_VALORACIONES','HVA_FECHA_FIN','4'),
T_VAL('MIG2_PRP_PROPUESTAS_PRECIOS','PRP_NUM_PROPUESTA','0'),
T_VAL('MIG2_ACT_PRP','ACT_PRP_ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG2_ACT_PRP','ACT_PRP_NUM_PROPUESTA','2'),
T_VAL('MIG2_GPV_GASTOS_PROVEEDORES','GPV_ID','0'),
T_VAL('MIG2_GPV_ACT_TBJ','GPT_GPV_ID','0'),
T_VAL('MIG2_GDE_GASTOS_DET_ECONOMICO','GDE_GPV_ID','0'),
T_VAL('MIG2_GGE_GASTOS_GESTION','GGE_GPV_ID','0'),
T_VAL('MIG2_GIM_GASTOS_IMPUGNACION','GIM_GPV_ID','0'),
T_VAL('MIG2_GIC_GASTOS_INFO_CONTABI','GIC_GPV_ID','0'),
T_VAL('MIG2_GPR_PROVISION_GASTOS','GPR_NUMERO_PROVISION_FONDOS','0'),
T_VAL('MIG2_PAC_PERIMETRO_ACTIVO','PAC_NUMERO_ACTIVO','0'),
T_VAL('MIG2_ACH_ACTIVOS_HITO','ACH_NUMERO_ACTIVO','0'),
T_VAL('MIG2_ACT_ACTIVO','ACT_NUMERO_ACTIVO','0'),
T_VAL('MIG2_ACQ_ACTIVO_ALQUILER','ACQ_NUMERO_ACTIVO','1'),
T_VAL('MIG2_AGR_AGRUPACIONES','AGR_UVEM','0'),
T_VAL('MIG2_PRH_PROP_HIST','PRH_PROPITARIO_CODIGO_UVEM','1'),
T_VAL('MIG2_PRH_PROP_HIST','PRH_NUMERO_ACTIVO','2'),
T_VAL('MIG2_PRH_PROP_HIST','PRH_FECHA_INICIO_PROMOTOR','3'),
T_VAL('MIG2_PRH_PROP_HIST','PRH_FECHA_FIN_PROMOTOR','4'),
T_VAL('MIG2_CEX_COMPRADOR_EXPEDIENTE','CEX_COD_COMPRADOR','2'),
T_VAL('MIG2_ACT_COE_CONDICIONES_ESPEC','COE_FECHA_DESDE','2'),
T_VAL('MIG2_OBF_OBSERVACIONES_OFERTAS','OBF_COD_TIPO_OBS','2'),
--T_VAL('MIG2_PVE_PROVEEDORES','PVE_COD_TIPO_PROVEEDOR','2'),
T_VAL('MIG2_PRD_PROVEEDOR_DIRECCION','PVE_COD_UVEM','2'),
T_VAL('MIG2_ACQ_ACTIVO_ALQUILER','ACQ_NUMERO_CONTRATO_ALQUILER','2'),
T_VAL('MIG_APC_PROP_CABECERA','PRO_COD_CARTERA','2'),
T_VAL('MIG_APA_PROP_ACTIVO','PRO_CODIGO_UVEM','2'),
T_VAL('MIG_ACA_CATASTRO_ACTIVO','CAT_REF_CATASTRAL','2'),
T_VAL('MIG_ACA_CARGAS_ACTIVO','ACT_NUMERO_ACTIVO','1'),
T_VAL('MIG_ACA_CARGAS_ACTIVO','TIPO_CARGA','2'),
T_VAL('MIG_ACA_CARGAS_ACTIVO','SUBTIPO_CARGA','3'),
T_VAL('MIG_ACA_CARGAS_ACTIVO','CRG_ORDEN','4'),
T_VAL('MIG_AID_INFCOMERCIAL_DISTR','DIS_NUM_PLANTA','2'),
T_VAL('MIG_AID_INFCOMERCIAL_DISTR','TIPO_HABITACULO','3'),
T_VAL('MIG2_GEA_GESTORES_ACTIVOS','GEA_NUMERO_ACTIVO','1'),
T_VAL('MIG2_GEA_GESTORES_ACTIVOS','GEA_GESTOR_ACTIVO','2'),
T_VAL('MIG2_GEA_GESTORES_ACTIVOS','GEA_TIPO_GESTOR','3'),
T_VAL('MIG2_GEO_GESTORES_OFERTAS','GEO_COD_OFERTA','1'),
T_VAL('MIG2_GEO_GESTORES_OFERTAS','GEO_GESTOR_ACTIVO','2'),
T_VAL('MIG2_GEO_GESTORES_OFERTAS','GEO_TIPO_GESTOR','3'),
T_VAL('MIG2_USU_USUARIOS','USU_USERNAME','1'),
T_VAL('MIG2_USU_USUARIOS','USU_CODIGO_PERFIL','2'),
T_VAL('MIG2_GRU_GRUPOS_USUARIOS','GRU_USERNAME_PRINCIPAL','1'),
T_VAL('MIG2_GRU_GRUPOS_USUARIOS','GRU_USERNAME','2')
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
						NOMBRE_INTERFAZ
						,CLAVE_DATO
						,CLAVE_POSICION
                    )
                    SELECT
                    	'''||V_TMP_VAL(1)||'''
                    	, '''||V_TMP_VAL(2)||'''
                    	, '''||V_TMP_VAL(3)||'''
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
